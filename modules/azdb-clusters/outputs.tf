output "cluster_id" {
  description = "Databricks cluster ID"
  value       = databricks_cluster.azdb-cluster.id
}