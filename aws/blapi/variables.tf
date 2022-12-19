variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "region" {
  type        = string
  description = "The AWS region which will be used."
}

variable "cloud_vpn_cidr" {
  type = list(string)
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_backup_retention_period" {
  type = number
}

variable "db_backup_window" {
  type = string
}

variable "db_maintenance_window" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "db_deletion_protection" {
  type    = bool
  default = true
}

variable "provider_role_arn" {
  type    = string
  default = ""
}

variable "snowflake_imports" {
  type = string
}

variable "kms_key" {
  type = string
}

variable "blapi_monitoring_interval" {
  type = number
}

variable "blapi_enabled_cloudwatch_logs_exports" {
  type    = list(string)
  default = ["postgresql"]
}

variable "blapi_db_cluster_engine" {
  type    = string
  default = "aurora-postgresql"
}

variable "blapi_db_cluster_engine_mode" {
  type    = string
  default = "provisioned"
}

variable "blapi_db_cluster_engine_version" {
  type    = string
  default = "13.8"
}

variable "blapi_db_cluster_identifier" {
  type = string
}

variable "blapi_db_cluster_instance_identifier" {
  type = string
}

variable "blapi_replica_min" {
  type = number
}

variable "blapi_copy_tags_to_snapshot" {
  type    = bool
  default = true
}

variable "blapi_service_name" {
  type    = string
  default = "blapi"
}

variable "blapi_kms_key" {
  type = string
}

variable "blapi_aurora_family" {
  type    = string
  default = "aurora-postgresql13"
}

variable "blapi_min_capacity" {
  type    = number
  default = 0.5
}

variable "blapi_max_capacity" {
  type    = number
  default = 4
}

variable "blapi_db_cluster_instance_type" {
  type    = string
  default = "db.t4g.medium"
}

variable "blapi_cluster_storage_encrypted" {
  type    = bool
  default = true
}

variable "blapi_apply_immediately" {
  type    = bool
  default = false
}

variable "blapi_performance_insights_enabled" {
  type = bool
}

variable "blapi_performance_insights_retention_period" {
  type    = number
  default = 7
}
