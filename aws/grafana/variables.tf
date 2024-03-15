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

variable "grafana_monitoring_interval" {
  type = number
}

variable "grafana_enabled_cloudwatch_logs_exports" {
  type    = list(string)
  default = ["postgresql"]
}

variable "grafana_db_cluster_engine" {
  type    = string
  default = "aurora-postgresql"
}

variable "grafana_db_cluster_engine_mode" {
  type    = string
  default = "provisioned"
}

variable "grafana_db_cluster_engine_version" {
  type    = string
  default = "13.8"
}

variable "grafana_db_cluster_identifier" {
  type = string
}

variable "grafana_db_cluster_instance_identifier" {
  type = string
}

variable "grafana_replica_min" {
  type = number
}

variable "grafana_copy_tags_to_snapshot" {
  type    = bool
  default = true
}

variable "grafana_service_name" {
  type    = string
  default = "grafana"
}

variable "grafana_kms_key" {
  type = string
}

variable "grafana_aurora_family" {
  type    = string
  default = "aurora-postgresql13"
}

variable "grafana_min_capacity" {
  type    = number
  default = 0.5
}

variable "grafana_max_capacity" {
  type    = number
  default = 4
}

variable "grafana_db_cluster_instance_type" {
  type    = string
  default = "db.serverless"
}

variable "grafana_cluster_storage_encrypted" {
  type    = bool
  default = true
}

variable "grafana_apply_immediately" {
  type    = bool
  default = false
}

variable "grafana_performance_insights_enabled" {
  type = bool
}

variable "grafana_performance_insights_retention_period" {
  type = number
}

variable "enable_grafana_read_replica" {
  type    = bool
  default = true
}

variable "grafana_enable_rds_alerting" {
  type    = bool
  default = false
}

variable "grafana_ca_cert_identifier" {
  type        = string
  description = "Identifier of the CA certificate for the DB instance."
  default     = "rds-ca-rsa4096-g1"
}
