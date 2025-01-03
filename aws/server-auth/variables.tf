variable "auth_private_subnet_ids" {
  type        = list(string)
  description = "The list of subnet IDs for VPC config of Lambda function"
}

variable "auth_vpc_id" {
  type        = string
  description = "The ID of the VPC which is used for security group"
}

variable "provisioner_server" {
  type        = string
  description = "The HTTP URL for the provisioner which is used as config for the Lambda function"
}

variable "community_webhook" {
  type        = string
  description = "The webhook URL to post notifications"
}

variable "deployment_name" {
  type        = string
  description = "The name of the deployment"
}

variable "api_gateway_vpc_endpoints" {
  type = list(string)
}

variable "environment" {
  type        = string
  description = "The name of the environment which will deploy to and will be added as a tag"
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
