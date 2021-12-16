variable "cidr_block" {
  type = string
}

variable "name" {
  type = string
}

variable "public_subnets" {
    type = list(string)
    description = "IP ranges for public subnets"
}

variable "tgw_id" {
    type = string
    description = "provide tgw id"
}