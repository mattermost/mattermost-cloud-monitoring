variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the endpoint will be created"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the endpoint"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID for the endpoint"
  type        = string
}

variable "service_name" {
  description = "Name of the Endpoint Service"
  type        = string
}
