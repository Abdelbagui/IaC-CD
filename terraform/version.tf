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
  subscription_id = "b8d59266-91c9-4141-a106-8ca2c5cd0155"

}

# terraform {
#   backend "azurerm" {
#     resource_group_name   = "HASMA_abdel_RG"
#     storage_account_name  = "baguistorage"
#     container_name        = "abdelbagui"
#     key                   = ".terraform.tfstate"
   
#   } 
#     # client_id             = var.client_id
#     # client_secret         = var.client_secret
#     # tenant_id             = var.tenant_id
#     # subscription_id       = var.subscription_id
# }