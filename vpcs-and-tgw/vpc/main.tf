
resource "aws_vpc" "this" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "pub-sub" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = "true" //it makes this a public subnet
  tags = {
    Name = "${var.name}-pub-sub-${var.public_subnets[count.index]}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-pub-sub-igw"
  }
}

resource "aws_route_table" "pub-route" {
  count  = length(var.public_subnets)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  route {
    cidr_block = "10.0.0.0/8"
    gateway_id = var.tgw_id
  }

  route {
    cidr_block = "172.16.0.0/12"
    gateway_id = var.tgw_id
  }

  route {
    cidr_block = "192.168.0.0/16"
    gateway_id = var.tgw_id
  }

  tags = {
    Name = "${var.name}-pub-sub-${var.public_subnets[count.index]}"
  }
  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.this
  ]
}


resource "aws_route_table_association" "pub-route-association" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.pub-sub[count.index].id
  route_table_id = aws_route_table.pub-route[count.index].id
}


resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  subnet_ids         = [for subnet in aws_subnet.pub-sub : subnet.id]
  transit_gateway_id = var.tgw_id
  vpc_id             = aws_vpc.this.id
  tags = {
    Name = var.name
  }
}

resource "aws_network_interface" "pub_ec2_nic" {
  count     = length(var.public_subnets)
  subnet_id = aws_subnet.pub-sub[count.index].id

  tags = {
    Name = "${var.name}-pub-ec2-${tostring(count.index)}-nic"
  }
}

resource "aws_instance" "pub_ec2" {
  count         = length(var.public_subnets)
  ami           = "ami-002068ed284fb165b" # us-east-2
  instance_type = "t2.micro"

  key_name = "ec2-key-pair"
  network_interface {
    network_interface_id = aws_network_interface.pub_ec2_nic[count.index].id
    device_index         = 0
  }


  tags = {
    Name = "${var.name}-pub-ec2-${tostring(count.index)}"
  }

}


resource "aws_network_interface_sg_attachment" "pub_sg_attachment" {
  count                = length(var.public_subnets)
  security_group_id    = aws_security_group.pub_sg[count.index].id
  network_interface_id = aws_network_interface.pub_ec2_nic[count.index].id
}

resource "aws_security_group" "pub_sg" {
  count  = length(var.public_subnets)
  vpc_id = aws_vpc.this.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    // This means, all ip address are allowed to ssh ! 
    // Do not do it in the production. 
    // Put your office or home address in it!
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }
  //If you do not add this rule, you can not reach the NGIX  
  tags = {
    Name = "${var.name}-pub-ec2-${tostring(count.index)}"
  }
}
