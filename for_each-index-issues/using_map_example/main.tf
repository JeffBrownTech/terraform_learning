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

resource "azurerm_resource_group" "rg" {
  name     = "storage-accounts-rg"
  location = "West US 2"
}

# Map of objects example
variable "storage_accounts" {
  type = map(object({
    name             = string
    replication_type = string
    account_tier     = string
  }))
}

resource "azurerm_storage_account" "sa" {
  for_each = var.storage_accounts
  name                     = each.value.name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_replication_type = each.value.replication_type
  account_tier             = each.value.account_tier
}