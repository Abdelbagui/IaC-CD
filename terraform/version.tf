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

subscription_id       = jsondecode(var.SECRET_CREDENTIALS)["subscriptionId"]
}

terraform {
  backend "azurerm" {
    resource_group_name  = "HASMA_abdel_RG" 
    storage_account_name = "baguistorage"                     
    container_name       = "abdelbagui"                     
    key                  = ".terraform.tfstate"    

    # client_id             = jsondecode(var.SECRET_CREDENTIALS)["clientId"]
    # client_secret         = jsondecode(var.SECRET_CREDENTIALS)["clientSecret"]
    # tenant_id             = jsondecode(var.SECRET_CREDENTIALS)["tenantId"]
    # subscription_id       = jsondecode(var.SECRET_CREDENTIALS)["subscriptionId"]
    
  }

}

