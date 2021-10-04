variable "environment" {
  description = "The name of the environment will run"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where database will run"
  type        = string
}

variable "region" {}

variable "cloud_vpn_cidr" {
  description = "The CIDR to access VPN"
  type        = string
}

variable "db_identifier" {
  description = "The database identifier"
  type        = string
}

variable "allocated_db_storage" {
  default     = 20
  description = "The allocated storage in gigabytes for the DB"
  type        = string

}

variable "db_engine_version" {
  default     = "13.3"
  description = "The engine version to use"
  type        = string
}

variable "db_instance_class" {
  default     = "t2.micro"
  description = "The instance type of the RDS instance"
  type        = string
}

variable "db_master_az" {
  description = "The availability zone for Master Database of provisioner"
  type        = string
}

variable "db_name" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
}

variable "db_username" {
  description = "Username for the master DB user"
  type        = string

}

variable "db_password" {
  description = "Password for the master DB user."
  type        = string

}

variable "db_backup_retention_period" {
  default     = 7
  description = "The days to retain backups for"
  type        = number

}

variable "db_backup_window" {
  default     = "12:01-12:31"
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string

}

variable "db_maintenance_window" {
  default     = "Sun:02:00-Sun:03:00"
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
}

variable "snapshot_identifier" {
  description = "RDS Snapshot to restore"
  type        = string

}

variable "storage_encrypted" {
  default = false
  type    = bool
}

variable "private_subnets" {
  description = "The list of private subnet IDs"
  type        = list(string)
}

variable "db_deletion_protection" {
  type    = bool
  default = true
}
