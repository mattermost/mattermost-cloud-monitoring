variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "cws_db_username" {
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

variable "cloud_vpn_cidr" {
  type = list(string)
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
  default = "14.10"
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
  default = "aurora-postgresql14"
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
  type = number
}

variable "connect_rds_ec2_security_group" {
  type = string
}

variable "enable_cws_read_replica" {
  type    = bool
  default = true
}

variable "cws_enable_bastion" {
  type    = bool
  default = true
}

variable "cws_enable_rds_alerting" {
  type    = bool
  default = false
}

variable "cws_ca_cert_identifier" {
  type        = string
  description = "Identifier of the CA certificate for the DB instance."
  default     = "rds-ca-rsa4096-g1"
}

variable "allow_major_version_upgrade" {
  type        = bool
  default     = false
  description = "Enable to allow major engine version upgrades when changing engine versions"
}

variable "iam_database_authentication_enabled" {
  type        = bool
  description = "Specifies whether or not mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled."
  default     = false
}

variable "teleport_cidr" {
  type        = list(string)
  description = "The Teleport CIDR block to allow access"
}

variable "is_calico_enabled" {
  type        = bool
  description = "Enable Calico network policies"
  default     = false
}

variable "calico_cidr" {
  type        = list(string)
  description = "The Calico CIDR block to allow access"
  default     = []
}
