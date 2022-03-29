variable "environment" {}

variable "deployment_name" {}

variable "vpc_id" {}

variable "destination_bucket" {}

variable "s3_cross_region_replication_enabled" {
  type    = bool
  default = true
} 

variable "destination_s3_kms_key" {}

variable "tags" {
  description = "Tags for bucket & cost calculation"
  type        = map(string)
  default     = {}
}

