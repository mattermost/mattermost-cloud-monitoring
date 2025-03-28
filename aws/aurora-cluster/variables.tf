variable "vpc_id" {
  description = "The VPC ID of the database cluster"
  type        = string
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = string
  default     = "5432"
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

variable "ca_cert_identifier" {
  type        = string
  description = "Identifier of the CA certificate for the DB instance."
  default     = "rds-ca-rsa4096-g1"
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
}

variable "publicly_accessible" {
  type        = bool
  description = "Bool to control if instance is publicly accessible"
  default     = false
}

variable "log_min_duration_statement" {
  type    = number
  default = 2000
}

variable "enable_rds_reader" {
  type    = bool
  default = true
}

variable "ram_memory_bytes" {
  default = {
    "db.t3.small"     = "2147483648"
    "db.t3.medium"    = "4294967296"
    "db.t3.large"     = "8589934592"
    "db.t4g.small"    = "2147483648"
    "db.t4g.medium"   = "4294967296"
    "db.t4g.large"    = "8589934592"
    "db.r5.large"     = "17179869184"
    "db.r5.xlarge"    = "34359738368"
    "db.r5.2xlarge"   = "68719476736"
    "db.r5.4xlarge"   = "137438953472"
    "db.r5.8xlarge"   = "274877906944"
    "db.r5.12xlarge"  = "412316860416"
    "db.r5.16xlarge"  = "549755813888"
    "db.r5.24xlarge"  = "824633720832"
    "db.r6g.large"    = "17179869184"
    "db.r6g.xlarge"   = "34359738368"
    "db.r6g.2xlarge"  = "68719476736"
    "db.r6g.4xlarge"  = "137438953472"
    "db.r6g.8xlarge"  = "274877906944"
    "db.r6g.12xlarge" = "412316860416"
    "db.r6g.16xlarge" = "549755813888"
    "db.r6g.24xlarge" = "824633720832"
  }
  type        = map(any)
  description = "The RAM memory of each instance type in Bytes."
}

variable "memory_alarm_limit" {
  default     = "100000000"
  description = "Limit to trigger memory alarm. Number in Bytes (100MB)"
  type        = string
}

variable "memory_cache_proportion" {
  default     = 0.75
  description = "Proportion of memory that is used for cache. By default it is 75%."
  type        = number
}

variable "enable_rds_alerting" {
  type    = bool
  default = false
}

variable "rds_sns_topic" {
  default     = "rds-cluster-events"
  description = "RDS events sns topic"
  type        = string
}

variable "allow_major_version_upgrade" {
  type        = bool
  description = "Enable to allow major engine version upgrades when changing engine versions"
}

variable "iam_database_authentication_enabled" {
  type        = bool
  description = "Specifies whether or not mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled."
  default     = false
}
