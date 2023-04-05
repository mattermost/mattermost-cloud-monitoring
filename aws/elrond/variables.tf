variable "environment" {
  type        = string
  description = "The environment to deploy the Elrond resources, dev, test, etc."
}

variable "vpc_id" {
  type        = string
  description = "The VPC to deploy the Elrond resources"
}

variable "cloud_vpn_cidr" {
  type        = list(string)
  description = "The cidr of the Cloud VPN to allow access from"
}

variable "db_username" {
  type        = string
  description = "The Elrond DB username"
}

variable "db_password" {
  type        = string
  description = "The Elrond DB password"
}

variable "db_backup_retention_period" {
  type        = string
  description = "The Elrond DB backup retention period"
}

variable "db_backup_window" {
  type        = string
  description = "The Elrond DB backup window"
}

variable "db_maintenance_window" {
  type        = string
  description = "The Elrond DB maintenance window"
}

variable "private_subnets" {
  type        = list(string)
  description = "The Elrond DB private subnets"
}

variable "db_deletion_protection" {
  type        = bool
  default     = true
  description = "Whether to enable DB deletion protection or not"

}

variable "provider_role_arn" {
  type        = string
  default     = ""
  description = "The provider IAM role arn"
}

variable "elrond_db_cluster_engine" {
  type    = string
  default = "aurora-postgresql"
}

variable "elrond_db_cluster_engine_mode" {
  type    = string
  default = "provisioned"
}

variable "elrond_db_cluster_engine_version" {
  type    = string
  default = "13.8"
}

variable "elrond_db_cluster_identifier" {
  type = string
}

variable "elrond_db_cluster_instance_identifier" {
  type = string
}

variable "elrond_replica_min" {
  type = number
}

variable "elrond_copy_tags_to_snapshot" {
  type    = bool
  default = true
}

variable "elrond_enabled_cloudwatch_logs_exports" {
  type    = list(string)
  default = ["postgresql"]
}

variable "elrond_monitoring_interval" {
  type = number
}

variable "elrond_service_name" {
  type    = string
  default = "elrond"
}

variable "elrond_kms_key" {
  type = string
}

variable "elrond_aurora_family" {
  type    = string
  default = "aurora-postgresql13"
}

variable "elrond_min_capacity" {
  type    = number
  default = 0.5
}

variable "elrond_max_capacity" {
  type    = number
  default = 4
}

variable "elrond_db_cluster_instance_type" {
  type    = string
  default = "db.serverless"
}

variable "elrond_cluster_storage_encrypted" {
  type    = bool
  default = true
}

variable "elrond_apply_immediately" {
  type    = bool
  default = false
}

variable "elrond_performance_insights_enabled" {
  type = bool
}

variable "elrond_performance_insights_retention_period" {
  type    = number
  default = 7
}

variable "enable_elrond_read_replica" {
  type    = bool
  default = true
}
