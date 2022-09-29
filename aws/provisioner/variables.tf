variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "cloud_vpn_cidr" {
  type = list(string)
}

variable "db_identifier" {
  type = string
}

variable "allocated_db_storage" {
  type = string
}

variable "db_engine_version" {
  type = string
}


variable "db_instance_class" {
  type = string
}

variable "db_master_az" {
  type = string
}

variable "db_read_replica_az" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
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

variable "snapshot_identifier" {
  type = string
}

variable "storage_encrypted" {
  type = bool
}

variable "private_subnets" {
  type = list(string)
}

variable "enable_provisioner_read_replica" {
  type = bool
}

variable "db_deletion_protection" {
  type    = bool
  default = true
}

variable "provider_role_arn" {
  type    = string
  default = ""
}

variable "provisioner_users" {
  type = list(string)
}

variable "grafana_cidr" {
  type        = list(any)
  description = "The centralised CIDR"
}
