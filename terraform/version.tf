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
    resource_group_name   = "-Win1-Serv-2022" # Utilisez la variable ici
    storage_account_name  = "baguistorage"
    container_name        = "abdelbagui"
    key                   = ".terraform.tfstate"
   
    # Les paramètres client_id, client_secret et tenant_id doivent être fournis via des variables d'environnement
    # qui ne devraient pas être dans le backend.
  } 
}