variable "share_name_test" {
  type        = string
  description = "The AWS share name to associate test Transit Gateways with."
}

variable "share_name_prod" {
  type        = string
  description = "The AWS share name to associate test Transit Gateways with."
}

variable "cloud_enterprise_test_tgw" {
  type        = string
  description = "The Cloud enterprise test Transit Gateway ID."
}

variable "cloud_enterprise_prod_tgw" {
  type        = string
  description = "The Cloud enterprise prod Transit Gateway ID."
}

variable "test_account_id" {
  type        = string
  description = "The Cloud Test account ID."
}

variable "prod_account_id" {
  type        = string
  description = "The Cloud Prod account ID."
}
