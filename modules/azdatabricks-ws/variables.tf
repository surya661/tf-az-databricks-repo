variable "databricks_name"{
  type = string

  }
variable "tags" {
  type = map(string)
  
}
  variable "region" {
  type    = string

}
variable "cidr" {
  type        = string
  default     = "10.0.0.0/24"
  description = "Network range"
}

variable "no_public_ip" {
  type        = bool
  default     = true
  description = "Defines whether Secure Cluster Connectivity (No Public IP) should be enabled."

}
