

data "databricks_node_type" "smallest" {
  local_disk = var.local_disk
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = var.long_term_support
}


data "databricks_current_user" "me" {}
