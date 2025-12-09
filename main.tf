/*module "azdatabricks-ws" {
  source          = "./modules/azdatabricks-ws"
  region          = "eastus"
  no_public_ip    = true
  databricks_name = "devdb"
  tags = {
    env   = "dev"
    owner = "surya"
  }

}*/

module "azdb-cluster" {
  source                  = "./modules/azdb-clusters"
  cluster_name            = "sample-cluster"
  min_workers             = 1
  max_workers             = 10
  num_workers             = null
  autotermination_minutes = 20
  enable_elastic_disk     = true


  instance_pool_id            = "0208-115531-flower505-pool-8ZAQWvUg"
  apply_policy_default_values = false
  single_user_name            = null
  kind                        = "interactive"
  is_pinned                   = false
  no_wait                     = false
  use_ml_runtime              = false
  is_single_node              = false
  idempotency_token           = "uc-metastore-cluster-unique-token-2024"
  policy_id                   = "E8F1A12F232940E782A16C59098C7A6F"
  provider_config             = {
    name = ""
    account_id = ""
    host = ""
    token = ""
    workspace_id = ""
  }
  node_type_id                = "Standard_DS3_v2"
  driver_instance_pool_id     = "Standard_DS3_v2"
 

  custom_tags = {
    environment = "dev"
    cost_center = "fin"
    owner       = "terranova"
  }
  spark_conf                   = { "spark.databricks.io.cache.enabled" = "true" }
  runtime_engine               = "PHOTON"
  enable_local_disk_encryption = true
  autoscale = {
    min_workers        = 2
    max_workers        = 10
    data_security_mode = "SINGLE_USER"
    spark_version      = "14.3.x-scala2.12"

    spark_conf = {
      "spark.databricks.repl.allowedLanguages" = ["python", "sql", "r"]
    }
  }

}