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

variable "min_subnet_free_ips" {
  type        = string
  description = "The number of free IPs which will be used in the lambda function as environment variable"
}

variable "mattermost_alerts_hook" {
  type        = string
  description = "The URL webhook to send the alert which will be used in the lambda function as environment variable"
}

variable "ebs_janitor_lambda_schedule" {
  type        = string
  description = "The schedule for AWS Cloud Lambda event rule"
}

variable "dryrun" {
  default     = "true"
  description = "Defines if lambda runs on dryRunMode or if does actual changes"
  type        = string
}
