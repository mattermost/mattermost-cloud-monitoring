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

variable "bucket" {
  description = "S3 bucket where the elb-cleanup lambda is stored"
  type        = string
}

variable "elb_cleanup_lambda_schedule" {
  default     = "rate(7 days)"
  description = "A rate expression and then runs on its defined schedule."
  type        = string
}

variable "dryrun" {
  default     = "true"
  description = "S3 bucket where the elb-cleanup lambda is stored"
  type        = string
}
