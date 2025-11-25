/*output "current_user" {
  value = data.external.me.result.name

}*/

output "databricks_host" {
  value = "https://${azurerm_databricks_workspace.azdb.workspace_url}/"

}