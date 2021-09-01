variable "environment" {}

variable "vpc_id" {}

variable "region" {}

variable "cloud_vpn_cidr" {}

variable "awat_db_identifier" {}

variable "allocated_db_storage" {}

variable "awat_db_engine_version" {}

variable "awat_db_instance_class" {}

variable "awat_db_master_az" {}

variable "awat_db_read_replica_az" {}

variable "awat_db_name" {}

variable "awat_db_username" {}

variable "awat_db_password" {}

variable "awat_db_backup_retention_period" {}

variable "awat_db_backup_window" {}

variable "awat_db_maintenance_window" {}

variable "awat_snapshot_identifier" {}

variable "storage_encrypted" {}

variable "private_subnets" {}

variable "enable_awat_read_replica" {}

variable "awat_db_deletion_protection" {
  type    = bool
  default = true
}

variable "enable_awat_bucket_restriction" {}

variable "cnc_user" {}

variable "allow_major_version_upgrade" {
  type    = bool
  default = false
}

variable "awat_db_storage_type" {
  type    = string
  default = "gp2"
}
