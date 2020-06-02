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

resource "azurerm_subnet" "subnet01" {
  name = "CRTestSN01"
  resource_group_name = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.vnet01.name
  address_prefix = "10.100.1.0/24"
}

resource "azurerm_public_ip" "CRTFEpip01" {
    name                         = "CRTestPIP01"
    location                     = "UKSouth"
    resource_group_name          = azurerm_resource_group.rg01.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "CR TFE Demo"
    }
}
  
