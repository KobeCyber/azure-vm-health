# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}


# Need to add a secure way to store subscription_id
provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}


