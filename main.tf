provider "azurerm" {
  version = "2.0"
  features {}
}

resource "azurerm_resource_group" "rg01" {
  name     = "crtestrg01"
  location = "UKSouth"
  tags = {
    environment = "CR TFE Demo"
  }
}

resource "azurerm_virtual_network" "vnet01" {
  name = "crtestvnet01"
  address_space = ["10.100.0.0/20"]
  location = "UKSouth"
  resource_group_name = azurerm_resource_group.rg01.name
  tags = {
    environment = "CR TFE Demo"
  }
}
  
