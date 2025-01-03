variable "private_subnet_ids" {
  type        = list(string)
  description = "The list of the private subnet IDs are used by elb-cleanup lambda"
}

variable "vpc_id" {
  description = "The ID of VPC is used by the elb-cleanup lamda"
  type        = string
}

variable "deployment_name" {
  description = "The name of the deployment for Lambda"
  type        = string
}

variable "elb_cleanup_lambda_schedule" {
  default     = "rate(7 days)"
  description = "A rate expression and then runs on its defined schedule."
  type        = string
}

variable "dryrun" {
  default     = "true"
  description = "Defines if lambda runs on dryRunMode or if does actual changes"
  type        = string
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
