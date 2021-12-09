variable "enable_loki_bucket_restriction" {
  type        = bool
  description = "Whether to enable Loki bucket policy or not"
}

variable "cnc_user" {
  type        = string
  description = "The command and control IAM user"
}

variable "environment" {
  type        = string
  description = "The cloud environment, dev, test, staging or prod."
}
