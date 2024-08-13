variable "environment" {
  type        = string
  description = "The environment will be created"
}

variable "tags_metrics_bucket" {
  type        = map(string)
  description = "Tags for prometheus metrics s3 bucket"
}

