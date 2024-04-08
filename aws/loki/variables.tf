variable "enable_loki_bucket_restriction" {
  type        = bool
  description = "Whether to enable Loki bucket policy or not"
}

variable "enable_loki_bucket_developers_restriction" {
  type        = bool
  description = "Whether to enable Loki developers bucket policy or not"
}

variable "enable_loki_bucket_developers" {
  type        = bool
  description = "Whether to deploy Loki developers bucket or not"
}

variable "environment" {
  type        = string
  description = "The cloud environment, dev, test, staging or prod."
}
