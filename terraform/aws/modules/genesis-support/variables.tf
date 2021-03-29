variable "share_name_test" {
    description = "The AWS share name to associate test Transit Gateways with."
}

variable "share_name_prod" {
    description = "The AWS share name to associate test Transit Gateways with."
}

variable "cloud_enterprise_test_tgw" {
    description = "The Cloud enterprise test Transit Gateway."
}

variable "cloud_enterprise_prod_tgw" {
    description = "The Cloud enterprise prod Transit Gateway."
}

variable "test_account_id" {
    description = "The Cloud Test account ID."
}

variable "prod_account_id" {
    description = "The Cloud Prod account ID."
}
