variable "rds_multitenant_dbinstance_name_prefix" {}

variable "environment" {}

variable "db_factory_horizontal_scaling_users" {}

variable "db_factory_vertical_scaling_users" {}

variable "rds_multitenant_dbcluster_tag_installation_database" {}

variable "horizontal_scaling_cronjob_suspend" {
  type    = bool
  default = false
}
