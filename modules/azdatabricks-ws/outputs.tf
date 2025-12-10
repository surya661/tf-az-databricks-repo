/*output "current_user" {
  value = data.external.me.result.name

}*/

output "databricks_host" {
  value = "https://${azurerm_databricks_workspace.azdb.workspace_url}/"

}
 output "rg-name" {
  value = azurerm_resource_group.rg.name
   
 }
 output "region" {
  value = var.region
   
 }

 output "no_public_ip" {
  value = var.no_public_ip
   
 }

 output "db_name" {
  value = var.databricks_name
   
 }

 output "tags" {
  value = azurerm_resource_group.rg.tags
 }

 output "azure_workspace_resource_id" {
  value = azurerm_databricks_workspace.azdb.workspace_id
   
 }