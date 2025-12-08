module "azdatabricks-ws" {
  source          = "./modules/azdatabricks-ws"
  region          = "eastus"
  no_public_ip    = true
  databricks_name = "devdb"
  tags = {
    env   = "dev"
    owner = "surya"
  }

}