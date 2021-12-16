module "vpc-dev" {
    source = "./vpc"
    cidr_block = "10.10.0.0/16"
    name = "vpc-dev"
    public_subnets = ["10.10.0.0/24"]
    tgw_id = aws_ec2_transit_gateway.this.id
}


module "vpc-shared" {
    source = "./vpc"
    cidr_block = "10.20.0.0/16"
    name = "vpc-shared"
    public_subnets = ["10.20.0.0/24"]
    tgw_id = aws_ec2_transit_gateway.this.id
}




resource "aws_ec2_transit_gateway" "this" {
  description     = "transit-gateway"
  amazon_side_asn = var.amazon_side_asn
  tags = {
    Name = "vpc-transit-gateway"
  }
}

resource "aws_customer_gateway" "main" {
  bgp_asn    = var.aviatrix_side_asn
  ip_address = var.aviatrix_primary_transit_gateway_public_ip
  type       = "ipsec.1"

  tags = {
    Name = var.aviatrix_primary_transit_gateway_name
  }
}


resource "aws_customer_gateway" "ha" {
  bgp_asn    = var.aviatrix_side_asn
  ip_address = var.aviatrix_secondary_transit_gateway_public_ip
  type       = "ipsec.1"

  tags = {
    Name = "avx-transit-hagw"
  }
}

resource "aws_vpn_connection" "primary" {
  customer_gateway_id = aws_customer_gateway.main.id
  transit_gateway_id  = aws_ec2_transit_gateway.this.id
  type                = aws_customer_gateway.main.type
  tags = {
    Name = var.primary_vpn_connection_name
  }
  tunnel1_preshared_key = var.tunnel1_preshared_key
  tunnel2_preshared_key = var.tunnel2_preshared_key
}

resource "aws_vpn_connection" "secondary" {
  customer_gateway_id = aws_customer_gateway.ha.id
  transit_gateway_id  = aws_ec2_transit_gateway.this.id
  type                = aws_customer_gateway.ha.type
  tags = {
    Name = var.secondary_vpn_connection_name
  }
  tunnel1_preshared_key = var.tunnel1_preshared_key
  tunnel2_preshared_key = var.tunnel2_preshared_key
}