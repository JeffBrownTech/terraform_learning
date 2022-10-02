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

variable "storage_account_name" {
  type        = string
  description = "Input name of the resource."

  validation {
    condition     = length(var.storage_account_name) >= 3 && length(var.storage_account_name) <= 24
    error_message = "The storage_account_name variable name must be 3-24 characters in length."
  }

  validation {
    condition     = can(regex("^jbt", var.storage_account_name))
    error_message = "The storage_account_name variable must have a 'jbt' prefix."
  }
}

variable "storage_access_tier" {
  type        = string
  description = "Access tier for storage account. Must be Hot or Cool."

  validation {
    condition     = var.storage_access_tier == "Hot" || var.storage_access_tier == "Cool"
    error_message = "The storage account must be set to Hot or Cool."
  }
}
