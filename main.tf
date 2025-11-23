terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
    random = "~>3.6"

    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "azurerm" {
  features {}

}

module "azdatabricks-ws" {
  source = "./modules/azdatabricks-ws"
}