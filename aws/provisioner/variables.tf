variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "cloud_vpn_cidr" {
  type = list(string)
}

variable "db_username" {
  type = string
}

variable "db_backup_retention_period" {
  type = string
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


variable "provisioner_users" {
  type = list(string)
}

variable "grafana_cidr" {
  type        = list(any)
  description = "The centralised CIDR"
}

variable "gitlab_cidr" {
  type        = list(any)
  description = "The gitlab CIDR"
}

variable "provisioner_db_cluster_engine" {
  type    = string
  default = "aurora-postgresql"
}

variable "provisioner_db_cluster_engine_mode" {
  type    = string
  default = "provisioned"
}

variable "provisioner_db_cluster_engine_version" {
  type    = string
  default = "14.10"
}

variable "provisioner_db_cluster_identifier" {
  type = string
}

variable "provisioner_db_cluster_instance_identifier" {
  type = string
}

variable "provisioner_replica_min" {
  type = number
}

variable "provisioner_copy_tags_to_snapshot" {
  type    = bool
  default = true
}

variable "provisioner_enabled_cloudwatch_logs_exports" {
  type    = list(string)
  default = ["postgresql"]
}

variable "provisioner_monitoring_interval" {
  type = number
}

variable "provisioner_service_name" {
  type    = string
  default = "provisioner"
}

variable "provisioner_kms_key" {
  type = string
}

variable "provisioner_aurora_family" {
  type    = string
  default = "aurora-postgresql14"
}

variable "provisioner_min_capacity" {
  type    = number
  default = 0.5
}

variable "provisioner_max_capacity" {
  type    = number
  default = 4
}

variable "provisioner_db_cluster_instance_type" {
  type    = string
  default = "db.serverless"
}

variable "provisioner_cluster_storage_encrypted" {
  type    = bool
  default = true
}

variable "provisioner_apply_immediately" {
  type    = bool
  default = false
}

variable "provisioner_performance_insights_enabled" {
  type = bool
}

variable "provisioner_performance_insights_retention_period" {
  type = number
}

variable "enable_provisioner_read_replica" {
  type    = bool
  default = true
}

variable "provisioner_enable_rds_alerting" {
  type    = bool
  default = false
}

variable "provisioner_ca_cert_identifier" {
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

variable "grant_privileges_to_schemas_sg" {
  type    = string
  default = ""
}
