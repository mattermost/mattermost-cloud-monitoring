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

variable "tags_loki_bucket" {
  type        = map(string)
  description = "Tags for loki s3 bucket"
}

variable "tags_bucket_loki_developers" {
  type        = map(string)
  description = "Tags for loki developers s3 bucket"
}
