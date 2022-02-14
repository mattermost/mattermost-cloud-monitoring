variable "rds_multitenant_dbinstance_name_prefix" {
  type        = string
  description = "The name of RDS db instance prefix"
}

variable "environment" {
  type        = string
  description = "The environment will be created"
}

variable "db_factory_horizontal_scaling_users" {
  type        = list(string)
  description = "The list of IAM users who have specific access for horizontal scaling"
}

variable "db_factory_vertical_scaling_users" {
  type        = list(string)
  description = "The list of IAM users who have specific access for vertical scaling"
}
