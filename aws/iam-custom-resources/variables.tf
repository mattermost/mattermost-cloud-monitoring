variable "environment" {
  description = "The environment"
  type        = string
}

variable "create_packer_user" {
  description = "Whether to create the packer user"
  type        = bool
  default     = false
}

variable "create_db_disaster_user" {
  description = "Whether to create the DB disaster recovery user"
  type        = bool
  default     = false
}

variable "create_exports_user" {
  description = "Whether to create the exports user"
  type        = bool
  default     = false
}
