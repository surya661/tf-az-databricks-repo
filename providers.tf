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
provider "databricks" {
  alias         = "accounts"
  host          = "adb-31100767013367.7.azuredatabricks.net"
  account_id    = "31100767013367"
  client_id     = "1c20b39e-d719-4095-9001-e3e367f16892"
  client_secret = "dosebfb2684c89c2228c43ff169f451fc1c2"
}
