variable "environment" {
  type = string
}

variable "enable_tempo_bucket_restriction" {
  type = bool
}

variable "tempo_bucket_tags" {
  type        = map(string)
  description = "Tags for tempo s3 bucket"
}
