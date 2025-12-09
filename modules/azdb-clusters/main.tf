terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}
/*
provider "databricks" {
  host = "https://adb-1217315119416603.3.azuredatabricks.net"

}

resource "databricks_cluster" "azdb-cluster" {
  cluster_name            = var.cluster_name
  spark_version           = try( var.spark_version , data.databricks_spark_version.latest_lts.id)
  node_type_id            = data.databricks_node_type.smallest.id
  # Either node_type_id OR instance_pool_id must be provided:
  #instance_pool_id        = var.instance_pool_id
  autotermination_minutes = var.autotermination_minutes
  driver_node_type_id     = var.driver_node_type_id
  ssh_public_keys         = var.ssh_public_keys
  spark_env_vars          = var.spark_env_vars
  spark_conf              = var.spark_conf
  custom_tags             = var.custom_tags
  enable_elastic_disk     = var.enable_elastic_disk
  runtime_engine          = var.runtime_engine
  enable_local_disk_encryption = var.enable_local_disk_encryption
  data_security_mode      = try(var.data_security_mode,null)
  init_scripts {
  abfss {
    destination = var.init_scripts
  }
  }
  autoscale {
    min_workers = var.autoscale != null ? var.autoscale.min_workers : 1
    max_workers = var.autoscale != null ? var.autoscale.max_workers : 5
  }
  azure_attributes {
    availability       = var.azure_attributes.availability
    first_on_demand    = var.azure_attributes.first_on_demand
    spot_bid_max_price = var.azure_attributes.spot_bid_max_price
  }
  num_workers = var.num_workers
  policy_id = var.policy_id
  apply_policy_default_values = var.apply_policy_default_values
  kind = var.kind
  single_user_name = var.single_user_name
  is_pinned = var.is_pinned
  idempotency_token = var.idempotency_token
  no_wait = var.no_wait
  
  
}
*/
