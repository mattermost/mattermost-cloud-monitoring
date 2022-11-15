variable "vpc_id" {
  description = "The VPC ID of the database cluster"
  type        = string
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = string
  default     = "5342"
}

variable "environment" {
  description = "The name of the environment which will deploy to and will be added as a tag"
  type        = string
}

variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = "aurora-postgresql"
}

variable "engine_mode" {
  description = "The engine mode to use"
  type        = string
  default     = "provisioned"
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
}

variable "password" {
  type        = string
  description = "If empty a random password will be created for each RDS Cluster and stored in AWS Secret Management."
}

variable "final_snapshot_identifier_prefix" {
  description = "The prefix name of your final DB snapshot when this DB instance is deleted"
  type        = string
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  type        = bool
}

variable "deletion_protection" {
  description = "Specifies if the DB instance should have deletion protection enabled"
  type        = bool
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = string
  default     = "7"
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created if automated backups are enabled using the BackupRetentionPeriod parameter"
  type        = string
}

variable "preferred_maintenance_window" {
  description = "The window to perform maintenance in"
  type        = string
}

variable "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted"
  type        = bool
}

variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
  type        = bool
}

variable "copy_tags_to_snapshot" {
  description = "Copy all Cluster tags to snapshots"
  type        = bool
}

variable "enabled_cloudwatch_logs_exports" {
  description = "Set of log types to enable for exporting to CloudWatch logs"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "instance_type" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = ""
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance"
  type        = number
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
  default     = false
}

variable "replica_min" {
  type        = number
  description = "Number of replicas to deploy initially with the RDS Cluster."
}

variable "creation_snapshot_arn" {
  type        = string
  description = "The ARN of the snapshot to create from"
  default     = ""
}

variable "cluster_identifier" {
  type        = string
  description = "The cluster identifier. If omitted, Terraform will assign a random, unique identifier."
}

variable "cluster_instance_identifier" {
  type        = string
  description = "The cluster instance identifier. If omitted, Terraform will assign a random, unique identifier."
}

variable "service_name" {
  type        = string
  description = "THe name of the service"
}

variable "kms_key" {
  type        = string
  description = "Key to keep your storage data encrypted at rest in all underlying storage for DB clusters."
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "The IDs of the security groups that will be assigned to the cluster nodes"
}

variable "aurora_family" {
  type        = string
  description = "The family of the DB parameter group."
  default     = "aurora-postgresql12"

}

variable "db_subnet_group_name" {
  type        = string
  description = "Required if publicly_accessible = false, Optional otherwise, Forces new resource) A DB subnet group to associate with this DB instance."
}

variable "min_capacity" {
  type        = number
  description = "The minimum capacity for an Aurora DB cluster in provisioned DB engine mode."
}

variable "max_capacity" {
  type        = number
  description = "The maximum capacity for an Aurora DB cluster in provisioned DB engine mode."
}

variable "performance_insights_retention_period" {
  type        = number
  description = "Amount of time in days to retain Performance Insights data"
  default     = 7
}

variable "publicly_accessible" {
  type        = bool
  description = "Bool to control if instance is publicly accessible"
  default     = false
}
