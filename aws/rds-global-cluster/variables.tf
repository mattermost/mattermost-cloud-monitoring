variable "environment" {
  description = "The name of the environment which will deploy to and will be added as a tag"
  type        = string
}

variable "primary_vpc_id" {
  description = "The VPC ID of the primary database cluster"
  type        = string
}

variable "secondary_vpc_id" {
  description = "The VPC ID of the secondary database cluster"
  type        = string
}

variable "source_region" {
  type        = string
  description = "The source region for an encrypted replica DB cluster."
}

variable "target_region" {
  type        = string
  description = "The target region for an encrypted replica DB cluster."
}


variable "global_cluster_identifier" {
  type        = string
  description = "(Required, Forces new resources) Global cluster identifier."
}


variable "engine" {
  type        = string
  description = "Name of the database engine to be used for this DB cluster. Terraform will only perform drift detection if a configuration value is provided. Valid values: aurora, aurora-mysql, aurora-postgresql."
}

variable "engine_version" {
  type        = string
  description = "Engine version of the Aurora global database."
}

variable "database_name" {
  type        = string
  description = "(Forces new resources) Name for an automatically created database on cluster creation."
}

variable "primary_cluster_identifier" {
  type        = string
  description = "Primary cluster identifier."
}

variable "master_username" {
  type        = string
  description = "Master username for rds cluster."
}

variable "master_password" {
  type        = string
  description = "Master password for rds cluster."
}

variable "primary_db_subnet_group_name" {
  type        = string
  description = "db subnet group name."
  default     = "default"
}

variable "secondary_db_subnet_group_name" {
  type        = string
  description = "db subnet group name."
  default     = "default"
}

variable "instance_class" {
  type        = string
  description = "instance class like db.r4.large etc."
}

variable "secondary_cluster_identifier" {
  type        = string
  description = "secondary cluster identifier."
}

variable "tags" {
  description = "Tags for Global Cluster & instances."
  type        = map(string)
  default     = {}
}

variable "primary_instances_count" {
  description = "Specify number of primary instances."
  type        = number
  default     = 2
}

variable "secondary_instances_count" {
  description = "Specify number of secondary instances."
  type        = number
  default     = 1
}

variable "backup_retention_period" {
  description = "(Optional) The days to retain backups for. Default 1."
  type        = number
  default     = 1
}

variable "preferred_backup_window" {
  type        = string
  description = "The daily time range during which automated backups are created if automated backups are enabled using the BackupRetentionPeriod parameter.Time in UTC."
  default     = "02:00-03:00"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted."
  default     = false
}

variable "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted"
  type        = bool
}

variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
  type        = bool
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance"
  type        = number
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
}

variable "aurora_family" {
  type        = string
  description = "The family of the DB parameter group."
  default     = "aurora-postgresql12"

}

variable "performance_insights_retention_period" {
  type        = number
  description = "Amount of time in days to retain Performance Insights data"
  default     = 7
}

variable "log_min_duration_statement" {
  type    = number
  default = 2000
}

variable "primary_vpc_security_group_ids" {
  type        = list(string)
  description = "The IDs of the security groups that will be assigned to the cluster nodes"
}

variable "secondary_vpc_security_group_ids" {
  type        = list(string)
  description = "The IDs of the security groups that will be assigned to the cluster nodes"
}
