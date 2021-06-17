variable "environment" {}

variable "vpn_cidr" {}

variable "vpc_id" {}

variable "private_subnet_ids" {}

variable "es_instance_type" {}

variable "es_volume_size" {}

variable "instance_count" {}

variable "dedicated_master_enabled" {}

variable "dedicated_master_count" {}

variable "dedicated_master_type" {}

variable "es_zone_awareness" {}

variable "es_zone_awareness_count" {}

variable "domain_name" {}

variable "es_version" {}

variable "mattermost_network" {}

variable "private_hosted_zoneid" {}

variable "custom_endpoint_enabled" {
  type    = bool
  default = true
}

variable "cw_retention_in_days" {
  type    = string
  default = "90"
}

variable "alarm_name_prefix" {
  description = "Alarm name prefix"
  type        = string
  default     = ""
}

variable "alarm_name_postfix" {
  description = "Alarm name postfix"
  type        = string
  default     = ""
}

variable "monitor_cluster_status_is_red" {
  description = "Enable monitoring of cluster status is in red"
  type        = bool
  default     = true
}

variable "monitor_cluster_status_is_yellow" {
  description = "Enable monitoring of cluster status is in yellow"
  type        = bool
  default     = true
}

variable "monitor_free_storage_space_too_low" {
  description = "Enable monitoring of cluster average free storage is to low"
  type        = bool
  default     = true
}

variable "monitor_cluster_index_writes_blocked" {
  description = "Enable monitoring of cluster index writes being blocked"
  type        = bool
  default     = true
}

variable "monitor_insufficient_available_nodes" {
  description = "Enable monitoring insufficient available nodes"
  type        = bool
  default     = true
}

variable "monitor_cpu_utilization_too_high" {
  description = "Enable monitoring of CPU utilization is too high"
  type        = bool
  default     = true
}

variable "monitor_jvm_memory_pressure_too_high" {
  description = "Enable monitoring of JVM memory pressure is too high"
  type        = bool
  default     = true
}

variable "monitor_master_cpu_utilization_too_high" {
  description = "Enable monitoring of CPU utilization of master nodes are too high. Only enable this when dedicated master is enabled"
  type        = bool
  default     = true
}

variable "monitor_master_jvm_memory_pressure_too_high" {
  description = "Enable monitoring of JVM memory pressure of master nodes are too high. Only enable this wwhen dedicated master is enabled"
  type        = bool
  default     = true
}

variable "monitor_master_not_reachable_from_node" {
  description = "Enable monitoring when master is not reachable from nodes"
  type        = bool
  default     = true
}

variable "free_storage_space_threshold" {
  description = "The minimum amount of available storage space in MegaByte."
  type        = number
  default     = 11000 //MB 10%
}

variable "min_available_nodes" {
  description = "The minimum available (reachable) nodes to have"
  type        = number
  default     = 1
}

variable "cpu_utilization_threshold" {
  description = "The maximum percentage of CPU utilization"
  type        = number
  default     = 80
}

variable "jvm_memory_pressure_threshold" {
  description = "The maximum percentage of the Java heap used for all data nodes in the cluster"
  type        = number
  default     = 80
}

variable "master_cpu_utilization_threshold" {
  description = "The maximum percentage of CPU utilization of master nodes"
  type        = number
  default     = 80
}

variable "master_jvm_memory_pressure_threshold" {
  description = "The maximum percentage of the Java heap used for master nodes in the cluster"
  type        = number
  default     = 80
}
