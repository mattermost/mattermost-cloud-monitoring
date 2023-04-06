variable "private_subnet_ids" {
  type        = list(string)
  description = "The list of the private subnet IDs"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the vpc for the security group of Lambda"
}

variable "deployment_name" {
  type        = string
  description = "The name of the deployment for Lambda"
}

variable "account_alerts_lambda_schedule" {
  type        = string
  description = "The schedule expression for a Cloudwatch Event rule to run Lambda periodically"
}

variable "min_subnet_free_ips" {
  type        = string
  description = "The number of free IPs which will be used in the lambda function as environment variable"
}

variable "mattermost_alerts_hook" {
  type        = string
  description = "The URL webhook to send the alert which will be used in the lambda function as environment variable"
}

variable "lambda_s3_bucket" {
  type        = string
  description = "The S3 bucket where the lambda function is stored"
}

variable "lambda_s3_key" {
  type        = string
  description = "The S3 key where the lambda function is stored"
}
