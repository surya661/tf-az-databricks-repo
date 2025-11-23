resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 5

}

data "external" "me" {
  program = [
    "bash", "-c",
    "az account show --query '{name:user.name}' --output json"
    ]
}

locals {
  prefix = "databricks${random_string.naming.result}"
  tags = {
    env = "dev"
    owner = data.external.me.result.name

  }
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.prefix}-rg"
  location = var.region
  tags     = local.tags

}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.prefix}-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [var.cidr]
  tags                = local.tags

}

resource "azurerm_network_security_group" "nsg" {
  name                = "${local.prefix}-nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags

}

resource "azurerm_subnet" "psnet" {
  name                 = "${local.prefix}-public-snet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.cidr, 3, 0)]

  delegation {
    name = "databricks"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
  }

}

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.psnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id

}

resource "azurerm_subnet" "prsnet" {
  name                 = "${local.prefix}-private-snet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.cidr, 3, 1)]

  delegation {
    name = "databricks"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
  }

}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.prsnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id

}

resource "azurerm_databricks_workspace" "azdb" {
  name                        = "${local.prefix}-workspace"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  sku                         = "premium"
  managed_resource_group_name = "${local.prefix}-workspace-rg"
  tags                        = local.tags
  
  custom_parameters {
    no_public_ip                                         = var.no_public_ip
    virtual_network_id                                   = azurerm_virtual_network.vnet.id
    private_subnet_name                                  = azurerm_subnet.prsnet.name
    public_subnet_name                                   = azurerm_subnet.psnet.name
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private.id
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public.id
  }

}

provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace.azdb.id
}

data "databricks_current_user" "me" {}
data "databricks_spark_version" "latest" {}
data "databricks_node_type" "smallest" {
  local_disk = true
}


resource "databricks_notebook" "db-note" {
    path = "${data.databricks_current_user.me.home}/terraform"
    language = "PYTHON"
    content_base64 = base64encode(<<EOT
    # Welcome to my Python notebook
    print("Hello, surya!")
    EOT
  )
}

resource "databricks_job" "db_job" {
    name = "db_job-poc"
    task {
      task_key = "one"
      notebook_task {
        notebook_path = databricks_notebook.db-note.path
      }

    }
    new_cluster {
      num_workers = 1
      spark_version = data.databricks_spark_version.latest.id
      node_type_id = data.databricks_node_type.smallest.id
    }
  
}
terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

