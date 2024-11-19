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

variable "environment" {
  description = "The name of the environment which will deploy to and will be added as a tag"
  type        = string
}

variable "db_username" {
  type = string
}

variable "provisioner_db_url" {
  type = string
}

variable "provisioner_db_user" {
  type = string
}

variable "excluded_clusters" {
  type = string
}

variable "activity_date" {
  type = string
}

variable "grant-privileges-to-schemas_lambda_schedule" {
  type        = string
  description = "The schedule for AWS Cloud Lambda event rule"
}

variable "lambda_s3_bucket" {
  type        = string
  description = "The S3 bucket where the lambda function is stored"
}

variable "lambda_s3_key" {
  type        = string
  description = "The S3 key where the lambda function is stored"
}
