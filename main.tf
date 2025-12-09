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
/*
module "azdb-cluster" {
  source                  = "./modules/azdb-clusters"
  cluster_name            = "sample-cluster"
  min_workers             = 1
  max_workers             = 10
  autotermination_minutes = 20
  enable_elastic_disk     = true
  custom_tags = {
  environment   = "dev"
  cost_center   = "fin"
  owner         = "terranova"
  }
  spark_conf              = { "spark.databricks.io.cache.enabled" = "true" }
  runtime_engine          = "PHOTON"
  enable_local_disk_encryption     = true
  autoscale = {
  min_workers = 2
  max_workers = 10
  data_security_mode = "SINGLE_USER"
  spark_version = "14.3.x-scala2.12"
  
  spark_conf = {
    "spark.databricks.repl.allowedLanguages" = join(",", var.allowed_languages)
  }
  }
  
}*/