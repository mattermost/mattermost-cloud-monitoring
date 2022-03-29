variable "environment" {}

variable "deployment_name" {}

variable "vpc_id" {}

variable "destination_bucket" {}

variable "s3_crr_enable" {
  type    = bool
  default = false
} 

variable "tags" {
  description = "Tags for bucket & cost calculation"
  type        = map(string)
  default     = {}
}
