variable "private_subnet_ids" {
  type        = list(string)
  description = "The list of the private subnet IDs for lambda VPC config"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID for the security group of Lambda"
}

variable "deployment_name" {
  type        = string
  description = "The name of the deployment"
}

variable "region" {
  type        = string
  description = "The region which will be used in lambda to cleanup unused images"
}

variable "account_id" {
  type        = string
  description = "The AWS account ID which will be used in lambda to cleanup unused images"
}

variable "bucket" {
  type        = string
  description = "The S3 bucket where the binary is located"
}

