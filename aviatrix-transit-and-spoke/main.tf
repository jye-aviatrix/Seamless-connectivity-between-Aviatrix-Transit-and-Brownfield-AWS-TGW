
module "spoke_azure_1" {
  source  = "terraform-aviatrix-modules/azure-spoke/aviatrix"
  version = "4.0.1"

  name = "az-eastus-dev"
  cidr = "10.200.16.0/24"
  region = "East US"
  account = "azure-test-jye"
  transit_gw = module.transit_azure_1.transit_gateway.gw_name

}

module "spoke_azure_2" {
  source  = "terraform-aviatrix-modules/azure-spoke/aviatrix"
  version = "4.0.1"

  name = "az-eastus-shared"
  cidr = "10.200.17.0/24"
  region = "East US"
  account = "azure-test-jye"
  transit_gw = module.transit_azure_1.transit_gateway.gw_name
  ha_gw = false

}

module "transit_azure_1" {
  source  = "terraform-aviatrix-modules/azure-transit/aviatrix"
  version = "4.0.1"

  cidr = "10.200.0.0/20"
  region = "East US"
  account = "azure-test-jye"
  name = "az-eastus"
  connected_transit = true
  learned_cidr_approval = true
  bgp_ecmp = true
  local_as_number = 65001

}