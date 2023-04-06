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

variable "lambda_s3_bucket" {
  type        = string
  description = "The S3 bucket where the lambda function is stored"
}

variable "lambda_s3_key" {
  type        = string
  description = "The S3 key where the lambda function is stored"
}
