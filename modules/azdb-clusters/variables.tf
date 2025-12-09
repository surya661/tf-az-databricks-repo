/*variable "azure_workspace_resource_id" {
  description = "Workspace resource ID from parent module"
  type        = string
}*/

# Required/Basic
variable "cluster_name" {
  description = "Databricks cluster name."
  type        = string
}
variable "spark_version" {
    description = "Spark version."
    type = string  
    default = "14.3.x-scala2.12"
    
}
variable "data_security_mode" {
    description = "Select the security features of the cluster."
    type = string
    default = "SINGLE_USER"
}

variable "autotermination_minutes" {
  description = "Minutes before cluster auto-termination."
  type        = number
  default     = 20
}

variable "min_workers" {
  description = "Minimum number of workers for autoscaling."
  type        = number
  default     = 1
}

variable "max_workers" {
  description = "Maximum number of workers for autoscaling."
  type        = number
  default     = 50
}

variable "local_disk" {
  description = "Require node type with local disk?"
  type        = bool
  default     = true
}

variable "long_term_support" {
  description = "Use latest long-term support Spark version."
  type        = bool
  default     = true
}

# Advanced additions
variable "driver_node_type_id" {
  description = "Custom node type of the Spark driver"
  type        = string
  default     = null
}
variable "ssh_public_keys" {
  description = "List of SSSH public key contents that will be added to each Spark node in this cluster."
  type        = list(string)
  default     = []
}
variable "spark_env_vars" {
  description = "Map with environment variable key-value pairs to fine-tune Spark clusters."
  type        = map(string)
  default     = {}
}
variable "spark_conf" {
  type        = map(any)
  description = "Map of Spark configuration settings for the Databricks cluster."
  default = {
    "spark.databricks.io.cache.enabled"       = true
    "spark.databricks.io.cache.maxDiskUsage"  = "50g"
    "spark.databricks.io.cache.maxMetaDataCache" = "1g"
    "spark.databricks.repl.allowedLanguages" = "python,sql,scala,r"
  }
}
variable "custom_tags" {
  description = "Additional tags for cluster resources. "
  type        = map(string)
  default     = {}
}
variable "enable_elastic_disk" {
  description = "Enable elastic disk?"
  type        = bool
  default     = true
}
variable "runtime_engine" {
  description = "Runtime engine (e.g., PHOTON)."
  type        = string
  default     = null
}
variable "enable_local_disk_encryption" {
  description = "Encrypt local disks using Azure Key Vault/key."
  type        = bool
  default     = false
}
variable "autoscale" {
  description = "Object with min_workers and max_workers for autoscaling."
  type        = object({ min_workers = number, max_workers = number })
  default     = null
}
variable "use_ml_runtime" {
    description = "Whenever ML runtime should be selected or not. Actual runtime is determined by spark_version (DBR release), this field use_ml_runtime, and whether node_type_id is GPU node or not."
    type = bool
     
}
variable "is_single_node" {
    description = "When set to true, Databricks will automatically set single node related custom_tags, spark_conf, and num_workers."
    type = bool
    default = false
  
}
variable "node_type_id" {
    description = "(Required - optional if instance_pool_id is given) Any supported databricks_node_type id. If instance_pool_id is specified, this field is not needed."
    type = string
  
}
variable "instance_pool_id" {
    description = "(Optional - required if node_type_id is not given) - To reduce cluster start time, you can attach a cluster to a predefined pool of idle instances. When attached to a pool, a cluster allocates its driver and worker nodes from the pool. If the pool does not have sufficient idle resources to accommodate the cluster's request, it expands by allocating new instances from the instance provider. When an attached cluster changes its state to TERMINATED, the instances it used are returned to the pool and reused by a different cluster."
    type = string
  
}
variable "driver_instance_pool_id" {
    description = "similar to instance_pool_id, but for driver node. If omitted, and instance_pool_id is specified, then the driver will be allocated from that pool."
    type = string
  
}
variable "policy_id" {
    description = "Identifier of Cluster Policy to validate cluster and preset certain defaults. The primary use for cluster policies is to allow users to create policy-scoped clusters via UI rather than sharing configuration for API-created clusters."
    type = string
  
}
variable "apply_policy_default_values" {
    description = "Whether to use policy default values for missing cluster attributes."
    type = bool
}
variable "kind" {
    description = "The kind of compute described by this compute specification."
    type = string
}
variable "data_security_mode_auto" {
    description = "Databricks will choose the most appropriate access mode depending on your compute configuration."
    type = bool
    default = false
}
variable "single_user_name" {
    description = "The user name of the user (or group name if kind if specified) to assign to an interactive cluster. "
    type = string
  
}
variable "idempotency_token" {
    description = "An optional token to guarantee the idempotency of cluster creation requests."
    type = string
}
variable "is_pinned" {
    description = "boolean value specifying if the cluster is pinned."
    type = bool
  
}
variable "no_wait" {
    description = "If true, the provider will not wait for the cluster to reach RUNNING state when creating the cluster, allowing cluster creation and library installation to continue asynchronously."
    type = bool
  
}
variable "provider_config" {
    description = "Configure the provider for management through account provider."
    type = object({
      name = string
      account_id = string
      host       = string
      token      = string
      workspace_id = string
    })
  
}
variable "num_workers" {
  description = "Number of worker nodes to create for fixed-size cluster "
  type = number
  
}
/*variable "allowedLanguages" {
  description = "List of allowed languages for Databricks notebooks"
  type = list(string)
  default = [ "python", "sql", "r" ]
}
variable "allowedLanguages" {

   description = "List of allowed languages for Databricks notebooks"
  type = list(string)
  default = [ "python", "sql", "r" ]
}*/
variable "allowedLanguages" {
  description = "List of allowed Databricks notebook languages (e.g., python, sql, r)"
  type        = list(string)
  default     = ["python", "sql", "r"]  # You may adjust as needed
}
variable "init_scripts" {
  description = "for an init script stored in ADLS:"
  type = string  
  default = "abfss://container@storage.dfs.core.windows.net/install-elk.sh"
}
variable "azure_attributes" {
  description = "Azure compute attributes"
  type = object({
    availability       = string
    first_on_demand    = number
    spot_bid_max_price = number
  })
  default = {
    availability       = "SPOT_WITH_FALLBACK_AZURE"
    first_on_demand    = 1
    spot_bid_max_price = 100
  }
}
