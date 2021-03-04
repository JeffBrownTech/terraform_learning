terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.40.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name = "rg-terraformchallenge"
  location = "westus2"
}

#Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${azurerm_resource_group.rg.location}-001"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "snet-${azurerm_resource_group.rg.location}-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Create network security group
resource "azurerm_network_security_group" "nsg" {
  name = "nsg-httpallow-001"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name = "HTTP-Inbound"
    priority = 150
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "80"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

# Create a virtual machine
module "server" {
  source = "./modules/terraform-azure-server"

  nsg_id                = azurerm_network_security_group.nsg.id
  subnet_id             = azurerm_subnet.subnet.id
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location

  vm_name               = "web001"
  vm_size               = "Standard_B1s"
  admin_username        = "cloud_admin"
  admin_password        = "asdf0u309@#F@#r2ef"

  os = {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2016-Datacenter"
    version = "latest"
  }
}

output "ip" {
  description = "Public IP of web server"
  value = module.server.pip
}