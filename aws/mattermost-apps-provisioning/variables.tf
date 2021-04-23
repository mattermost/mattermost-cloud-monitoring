variable "deployment_name" {
  type        = string
  description = "The name of the deployment name which will be used as prefix for naming resources"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID which will ne used for security group of lambda function"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}
