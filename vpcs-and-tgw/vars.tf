variable "aviatrix_primary_transit_gateway_public_ip" {
  type = string
  description = "Provide Aviatrix Primary Transit Gateway public IP"
  default = "20.85.130.67"
}

variable "aviatrix_secondary_transit_gateway_public_ip" {
  type = string
  description = "Provide Aviatrix Secondary Transit Gateway public IP"
  default = "20.85.134.231"
}

variable "tunnel1_preshared_key" {
  type        = string
  description = "The pre-shared key for first tunnel"

  validation {
    condition     = length(var.tunnel1_preshared_key) > 7 && length(var.tunnel1_preshared_key) < 65 && !(can(regex("^0", var.tunnel1_preshared_key))) && can(regex("[a-zA-Z0-9_.]+", var.tunnel1_preshared_key))
    error_message = "A 8-64 character string with alphanumeric, underscore(_), and dot(.). It cannot start with 0."
  }
  default = "s7Blk2sHZjHpCIAG.2sT.dR3H3GWZLHz"
}


variable "tunnel2_preshared_key" {
  type        = string
  description = "The pre-shared key for second tunnel"

  validation {
    condition     = length(var.tunnel2_preshared_key) > 7 && length(var.tunnel2_preshared_key) < 65 && !(can(regex("^0", var.tunnel2_preshared_key))) && can(regex("[a-zA-Z0-9_.]+", var.tunnel2_preshared_key))
    error_message = "A 8-64 character string with alphanumeric, underscore(_), and dot(.). It cannot start with 0."
  }
  default = "ssP_IMA94JXhCgErN9pEMDvnFAxahTsc"
}




variable "primary_vpn_connection_name" {
  type = string
  description = "Name of the primary VPN connection"
  default = "Connection1"
}

variable "secondary_vpn_connection_name" {
  type = string
  description = "Name of the secondary VPN connection"
  default = "Connection2"
}


variable "amazon_side_asn" {
  type = string
  description = "Provide AWS TGW ASN number"
  default = 65100
}

variable "aviatrix_side_asn" {
  type = string
  description = "Provide Aviatrix Transit Gateway ASN number"
  default = 65001
}

variable "aviatrix_primary_transit_gateway_name" {
  type = string
  description = "Provide Aviatrix Primary Transit Gateway name"
  default = "avx-transit"
}

variable "aviatrix_ha_transit_gateway_name" {
  type = string
  description = "Provide Aviatrix HA Transit Gateway name"
  default = "avx-transit-hagw"
}
