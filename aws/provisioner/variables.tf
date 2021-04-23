variable "environment" {}

variable "vpc_id" {}

variable "region" {}

variable "cloud_vpn_cidr" {}

variable "db_identifier" {}

variable "allocated_db_storage" {}

variable "db_engine_version" {}

variable "db_instance_class" {}

variable "db_master_az" {}

variable "db_read_replica_az" {}

variable "db_name" {}

variable "db_username" {}

variable "db_password" {}

variable "db_backup_retention_period" {}

variable "db_backup_window" {}

variable "db_maintenance_window" {}

variable "snapshot_identifier" {}

variable "storage_encrypted" {}

variable "private_subnets" {}

variable "enable_provisioner_read_replica" {}

variable "db_deletion_protection" {
  type    = bool
  default = true
}

variable "provider_role_arn" {
  type    = string
  default = ""
}

variable "provisioner_users" {}
