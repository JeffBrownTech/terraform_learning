terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}
provider "azurerm" {
  features {}
}

variable "storage_accounts" {
  type = list(object({
    name             = string
    replication_type = string
    account_tier     = string
  }))
}

resource "azurerm_resource_group" "rg" {
  name     = "storage-accounts-rg"
  location = "West US 2"
}

resource "azurerm_storage_account" "sa1" {
  for_each = { for key, value in var.storage_accounts : key => value }    # Creates but with index values strings ["0"], ["1"]

  name                     = each.value.name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_replication_type = each.value.replication_type
  account_tier             = each.value.account_tier
}

resource "azurerm_storage_account" "sa2" {
  for_each = { for storage in var.storage_accounts : storage.name => storage }    # Creates with indexes of the storage account name ["jeffbrowntech001"], etc.

  name                     = each.value.name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_replication_type = each.value.replication_type
  account_tier             = each.value.account_tier
}
