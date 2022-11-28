variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "cws_db_identifier" {
  type = string
}

variable "cws_allocated_db_storage" {
  type = string
}

variable "cws_db_engine_version" {
  type = string
}

variable "cws_db_instance_class" {
  type = string
}

variable "cws_db_master_az" {
  type = string
}

variable "cws_db_read_replica_az" {
  type = string
}

variable "cws_db_name" {
  type = string
}

variable "cws_db_username" {
  type = string
}

variable "cws_db_password" {
  type = string
}

variable "cws_db_backup_retention_period" {
  type = number
}

variable "cws_db_backup_window" {
  type = string
}

variable "cws_db_maintenance_window" {
  type = string
}

variable "cws_storage_encrypted" {
  type = bool
}

variable "cloud_vpn_cidr" {
  type = list(string)
}

variable "enable_cws_read_replica" {
  type = bool
}

variable "performance_insights_enabled" {
  type    = bool
  default = false
}

variable "performance_insights_retention_period" {
  type    = number
  default = 7
}

variable "cws_db_deletion_protection" {
  type    = bool
  default = true
}

variable "cws_db_cluster_engine" {
  type    = string
  default = "aurora-postgresql"
}

variable "cws_db_cluster_engine_mode" {
  type    = string
  default = "provisioned"
}

variable "cws_db_cluster_engine_version" {
  type    = string
  default = "13.8"
}

variable "cws_db_cluster_identifier" {
  type = string
}

variable "cws_db_cluster_instance_identifier" {
  type = string
}

variable "cws_replica_min" {
  type = number
}

variable "cws_copy_tags_to_snapshot" {
  type    = bool
  default = true
}

variable "cws_enabled_cloudwatch_logs_exports" {
  type    = list(string)
  default = ["postgresql"]
}

variable "cws_monitoring_interval" {
  type = number
}

variable "cws_service_name" {
  type    = string
  default = "cws"
}

variable "cws_kms_key" {
  type = string
}

variable "cws_aurora_family" {
  type    = string
  default = "aurora-postgresql13"
}

variable "cws_min_capacity" {
  type    = number
  default = 0.5
}

variable "cws_max_capacity" {
  type    = number
  default = 4
}

variable "cws_db_cluster_instance_type" {
  type    = string
  default = "db.serverless"
}

variable "cws_cluster_storage_encrypted" {
  type    = bool
  default = true
}

variable "cws_apply_immediately" {
  type    = bool
  default = false
}

variable "cws_performance_insights_enabled" {
  type = bool
}

variable "cws_performance_insights_retention_period" {
  type    = number
  default = 7
}
