terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}


provider "azurerm" {
  features {}

  
  subscription_id = var.subscription_id
}

terraform {
  backend "azurerm" {
    resource_group_name   = "HASMA_abdel_RG"
    storage_account_name  = "baguistorage"
    container_name        = "abdelbagui"
    key                   = ".terraform.tfstate"
    
    client_id             = var.client_id
    client_secret         = var.client_secret
    tenant_id             = var.tenant_id
    subscription_id       = var.subscription_id
  }
}