variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "cloud_vpn_cidr" {
  type = string
}

variable "awat_db_identifier" {
  type = string
}

variable "allocated_db_storage" {
  type = string
}

variable "awat_db_engine_version" {
  type = string
}

variable "awat_db_instance_class" {
  type = string
}

variable "awat_db_master_az" {
  type = string
}

variable "awat_db_read_replica_az" {
  type = string
}

variable "awat_db_name" {
  type = string
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

variable "awat_snapshot_identifier" {
  type = string
}

variable "storage_encrypted" {
  type = bool
}

variable "private_subnets" {
  type = list(string)
}

variable "enable_awat_read_replica" {
  type = bool
}

variable "awat_db_deletion_protection" {
  type    = bool
  default = true
}

variable "enable_awat_bucket_restriction" {
  type = bool
}

variable "cnc_user" {
  type = string
}

variable "allow_major_version_upgrade" {
  type    = bool
  default = false
}

variable "awat_db_storage_type" {
  type    = string
  default = "gp2"
}
