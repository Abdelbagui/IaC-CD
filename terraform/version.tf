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

  client_id       = jsondecode(var.SECRET_CREDENTIALS)["client_id"]
  client_secret   = jsondecode(var.SECRET_CREDENTIALS)["client_secret"]
  tenant_id       = jsondecode(var.SECRET_CREDENTIALS)["tenant_id"]
  subscription_id = jsondecode(var.SECRET_CREDENTIALS)["subscription_id"]
}


terraform {
  backend "azurerm" {
    resource_group_name  = "HASMA_abdel_RG" 
    storage_account_name = "baguistorage"                     
    container_name       = "abdelbagui"                     
    key                  = ".terraform.tfstate"        
  }
}

