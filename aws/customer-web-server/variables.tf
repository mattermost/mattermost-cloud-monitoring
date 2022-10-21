variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "cws_db_identifier" {
  type = string
}

variable "cws_allocated_db_storage" {
  type = string
}

variable "cws_db_engine_version" {
  type = string
}

variable "cws_db_instance_class" {
  type = string
}

variable "cws_db_master_az" {
  type = string
}

variable "cws_db_read_replica_az" {
  type = string
}

variable "cws_db_name" {
  type = string
}

variable "cws_db_username" {
  type = string
}

variable "cws_db_password" {
  type = string
}

variable "cws_db_backup_retention_period" {
  type = number
}

variable "cws_db_backup_window" {
  type = string
}

variable "cws_db_maintenance_window" {
  type = string
}

variable "cws_storage_encrypted" {
  type = bool
}

variable "cloud_vpn_cidr" {
  type = list(string)
}

variable "enable_cws_read_replica" {
  type = bool
}

variable "performance_insights_enabled" {
  type    = bool
  default = false
}

variable "performance_insights_retention_period" {
  type    = number
  default = 7
}
