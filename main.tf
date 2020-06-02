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
  
resource "azurerm_network_security_group" "nsg01" {
    name                = "CRTestNSG01"
    location            = "UKSouth"
    resource_group_name = azurerm_resource_group.rg01.name
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "CR TFE Demo"
    }
}

resource "azurerm_network_interface" "NIC01" {
    name                        = "CRTestNIC01"
    location                    = "UKSouth"
    resource_group_name         = azurerm_resource_group.rg01.name

    ip_configuration {
        name                          = "CRTestNic01Config"
        subnet_id                     = azurerm_subnet.subnet01.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.CRTFEpip01.id
    }

    tags = {
        environment = "CR TFE Demo"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "NicNSG01" {
    network_interface_id      = azurerm_network_interface.NIC01.id
    network_security_group_id = azurerm_network_security_group.nsg01.id
}

resource "azurerm_linux_virtual_machine" "vm01" {
    name                  = "CRTFETestVm01"
    location              = "UKSouth"
    resource_group_name   = azurerm_resource_group.rg01.name
    network_interface_ids = [azurerm_network_interface.NIC01.id]
    size                  = "Standard_B2s"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    computer_name  = "CRTFETestVM01"
    admin_username = "azureuser"
    disable_password_authentication = true
        
    admin_ssh_key {
        username       = "azureuser"
        public_key     = var.ssh_public_key
    }

    tags = {
        environment = "CR TFE Demo"
    }
}
