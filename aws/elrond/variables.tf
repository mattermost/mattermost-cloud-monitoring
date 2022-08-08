variable "environment" {
  type        = string
  description = "The environment to deploy the Elrond resources, dev, test, etc."
}

variable "vpc_id" {
  type        = string
  description = "The VPC to deploy the Elrond resources"
}

variable "region" {
  type        = string
  description = "The region to deploy the Elrond resources"
}

variable "cloud_vpn_cidr" {
  type        = string
  description = "The cidr of the Cloud VPN to allow access from"
}

variable "db_identifier" {
  type        = string
  description = "The Elrond DB identifier"
}

variable "allocated_db_storage" {
  type        = string
  description = "The Elrond DB allocated storage"
}

variable "db_engine_version" {
  type        = string
  description = "The Elrond DB engine"
}

variable "db_instance_class" {
  type        = string
  description = "The Elrond DB instance class"
}

variable "db_master_az" {
  type        = string
  description = "The Elrond DB master node AZ"
}

variable "db_read_replica_az" {
  type        = string
  description = "The Elrond DB read replica AZ"
}

variable "db_name" {
  type        = string
  description = "The Elrond DB name"
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

variable "snapshot_identifier" {
  type        = string
  description = "The Elrond DB snapshot identifier"
}

variable "storage_encrypted" {
  type        = bool
  description = "Whether to encrypt DB data or not"
}

variable "private_subnets" {
  type        = list(string)
  description = "The Elrond DB private subnets"
}

variable "enable_elrond_read_replica" {
  type        = bool
  description = "Whether to encrypt DB data or not"
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
