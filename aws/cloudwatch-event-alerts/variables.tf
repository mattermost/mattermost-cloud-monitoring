variable "pagerduty_apikey" {
  type        = string
  description = "The API key for the PagerDuty integration"
}

variable "community_webhook" {
  type        = string
  description = "The URL webhook to post the messages"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}

variable "lambda_s3_bucket" {
  type        = string
  description = "The S3 bucket where the lambda function is stored"
}

variable "lambda_s3_key" {
  type        = string
  description = "The S3 key where the lambda function is stored"
}

variable "enable_arm64" {
  description = "Enable ARM64 architecture for Lambda"
  type        = bool
  default     = false
}
