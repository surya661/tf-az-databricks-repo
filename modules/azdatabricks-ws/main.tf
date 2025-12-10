/*resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 5

}
data "external" "me" {
  program = [
    "bash", "-c",
    "az account show --query '{name:user.name}' --output json"
    ]
}*/

resource "azurerm_resource_group" "rg" {
  name     = "${var.databricks_name}-rg"
  location = var.region
  tags     = var.tags

}

resource "azurerm_virtual_network" "vnet" {
  name                = "${azurerm_resource_group.rg.name}-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [var.cidr]
  tags                = var.tags

}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.databricks_name}-nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags

}

resource "azurerm_subnet" "psnet" {
  name                 = "${var.databricks_name}-public-snet"
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
  name                 = "${var.databricks_name}-private-snet"
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
  name                        = "${var.databricks_name}-workspace"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  sku                         = "premium"
  managed_resource_group_name = "${var.databricks_name}-workspace-rg"
  tags                        = var.tags
  
  custom_parameters {
    no_public_ip                                         = var.no_public_ip
    virtual_network_id                                   = azurerm_virtual_network.vnet.id
    private_subnet_name                                  = azurerm_subnet.prsnet.name
    public_subnet_name                                   = azurerm_subnet.psnet.name
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private.id
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public.id
  }

}