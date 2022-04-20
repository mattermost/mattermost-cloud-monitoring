variable "environment" {}

variable "vpc_id" {}

variable "region" {}

variable "cloud_vpn_cidr" {}

variable "db_identifier" {
  type = string
}

variable "allocated_db_storage" {}

variable "db_engine_version" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "db_writer_az" {}

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

variable "private_subnets" {}

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
