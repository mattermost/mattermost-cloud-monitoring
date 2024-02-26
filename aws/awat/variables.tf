variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "cloud_vpn_cidr" {
  type = list(string)
}

variable "awat_db_username" {
  type = string
}

variable "awat_db_password" {
  type = string
}

variable "awat_db_backup_retention_period" {
  type = number
}

variable "awat_db_backup_window" {
  type = string
}

variable "awat_db_maintenance_window" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "awat_db_deletion_protection" {
  type    = bool
  default = true
}

variable "enable_awat_bucket_restriction" {
  type = bool
}

variable "awat_performance_insights_enabled" {
  type = bool
}

variable "awat_performance_insights_retention_period" {
  type = number
}

variable "awat_db_cluster_engine" {
  type    = string
  default = "aurora-postgresql"
}

variable "awat_db_cluster_engine_mode" {
  type    = string
  default = "provisioned"
}

variable "awat_db_cluster_engine_version" {
  type    = string
  default = "13.7"
}

variable "awat_db_cluster_identifier" {
  type = string
}

variable "awat_db_cluster_instance_identifier" {
  type = string
}

variable "awat_replica_min" {
  type = number
}

variable "awat_apply_immediately" {
  type    = bool
  default = false
}

variable "awat_copy_tags_to_snapshot" {
  type    = bool
  default = true
}

variable "awat_enabled_cloudwatch_logs_exports" {
  type    = list(string)
  default = ["postgresql"]
}

variable "awat_monitoring_interval" {
  type = number
}

variable "awat_service_name" {
  type    = string
  default = "awat"
}

variable "awat_kms_key" {
  type = string
}

variable "awat_aurora_family" {
  type    = string
  default = "aurora-postgresql13"
}

variable "awat_min_capacity" {
  type    = number
  default = 0.5
}

variable "awat_max_capacity" {
  type    = number
  default = 4
}

variable "awat_db_cluster_instance_type" {
  type    = string
  default = "db.serverless"
}

variable "awat_cluster_storage_encrypted" {
  type    = bool
  default = true
}

variable "enable_awat_read_replica" {
  type    = bool
  default = true
}

variable "open_oidc_provider_url" {
  type        = string
  description = "The Open OIDC Provider URL for a specific cluster"
}

variable "open_oidc_provider_arn" {
  type        = string
  description = "The Open OIDC Provider ARN for a specific cluster"
}

variable "serviceaccount" {
  type        = string
  description = "Service Account, with which we want to associate IAM permission"
}

variable "namespace" {
  type        = string
  description = "The namespace, which host the service account & target application "
}

variable "awat_enable_rds_alerting" {
  type    = bool
  default = false
}

variable "awat_ca_cert_identifier" {
  type        = string
  description = "Identifier of the CA certificate for the DB instance."
  default     = "rds-ca-rsa4096-g1"
}

variable "cloud_import_account_number" {
  type        = string
  description = "value of the account number of the import account"
}
