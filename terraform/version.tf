terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

# Définition de la variable SECRET_CREDENTIALS
variable "SECRET_CREDENTIALS" {}

# Décodez les informations d'authentification dans des variables locales
locals {
  credentials = jsondecode(var.SECRET_CREDENTIALS)
}

provider "azurerm" {
  features {}

  subscription_id = local.credentials["subscriptionId"]
}

terraform {
  backend "azurerm" {
    resource_group_name   = "HASMA_abdel_RG"
    storage_account_name  = "baguistorage"
    container_name        = "abdelbagui"
    key                   = ".terraform.tfstate"
    
    client_id             = local.credentials["clientId"]
    client_secret         = local.credentials["clientSecret"]
    tenant_id             = local.credentials["tenantId"]
    subscription_id       = local.credentials["subscriptionId"]
  }
}