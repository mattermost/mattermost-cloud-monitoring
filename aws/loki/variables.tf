variable "enable_loki_bucket_restriction" {
  type        = bool
  description = "Whether to enable Loki bucket policy or not"
}

variable "environment" {
  type        = string
  description = "The cloud environment, dev, test, staging or prod."
}
