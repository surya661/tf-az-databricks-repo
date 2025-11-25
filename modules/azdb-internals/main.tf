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
