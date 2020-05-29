provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg01" {
  name     = "crtestrg01"
  location = "UKSouth"
}
