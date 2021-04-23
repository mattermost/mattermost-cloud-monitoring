variable "environment" {
  type        = string
  description = "The name of the environment which will deploy to and will be added as a tag"
}

variable "provisioner_users" {
  type        = list(string)
  description = "The IAM user names which will Allowed for S3 operation (Get, Delete Objects) in the IAM Policy Document of the bucket"
}

variable "cnc_user" {
  type        = string
  description = "The IAM user name which will Allowed  for S3 operation in the IAM Policy Document of the bucket"
}

variable "force_destroy_state_bucket" {
  type        = bool
  description = "The flag to enable or disable force destroy of the S3 state"
  default     = false
}
