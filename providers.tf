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

provider "azurerm" {
  alias           = "uat-sub"
  subscription_id = "0000000000000000000000000"

}