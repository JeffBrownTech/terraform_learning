# Terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.40.0"
     }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform_learning"
    storage_account_name = "jbtterraformlearning"
    container_name       = "terraformstate"
    key                  = "dev.terraform.tfstate"
  }
}

#Azure provider
provider "azurerm" {
  features {}
}

#create resource group
resource "azurerm_resource_group" "rg" {
    name     = "rg-terrformchallenge"
    location = "westus2"
    tags      = {
      Environment = "terraexample"
    }
}

#Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "vnet-dev-westus2-001"
    address_space       = ["10.1.0.0/16"]
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "snet-dev-westus2-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.0.0/24"]
}

# Create a network interface
resource "azurerm_network_interface" "nic" {
  name                = "nic-01-vm01-dev-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

  # Create a virtual machine
resource "azurerm_windows_virtual_machine" "vm" {
  name                  = "vm01"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_B1s"
  admin_username        = "adminuser"
  admin_password        = "P@$$w0rd1234!" # not a real password or best practice!
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}