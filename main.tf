provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg01" {
  name     = "crtestrg01"
  location = "UKSouth"
  tags = {
    environment = "CR TFE Demo"
  }
}

resource "azure_virtual_network" "vnet01" {
  name = "crtestvnet01"
  address_space = ["10.100.0.0/20"]
  location = "UKSouth"
  resource_group_name = "azure_resource_group.rg01.name"
  tags = {
    environment = "CR TFE Demo"
  }
}
  
