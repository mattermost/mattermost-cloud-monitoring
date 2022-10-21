variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "region" {
  type        = string
  description = "The AWS region which will be used."
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

variable "db_writer_az" {
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
  type = number
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

variable "db_deletion_protection" {
  type    = bool
  default = true
}

variable "provider_role_arn" {
  type    = string
  default = ""
}

variable "storage_type" {
  type    = string
  default = "gp2"
}

variable "snowflake_imports" {
  type = string
}

variable "kms_key" {
  type = string
}

variable "performance_insights_enabled" {
  type    = bool
  default = false
}

variable "performance_insights_retention_period" {
  type    = number
  default = 7
}
