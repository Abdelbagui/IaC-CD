terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.67.0"
    }
  }

  required_version = ">= 0.14"
}
provider "azurerm" {
  features {}
  skip_provider_registration = true
}
