
variable "private_subnet_ids" {
  type        = list(string)
  description = "The list of the private subnet IDs for Lambda function"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the vpc for the security group of Lambda"
}

variable "deployment_name" {
  type        = string
  description = "The name of the deployment for Lambda"
}

variable "grafana_lambda_schedule" {
  type        = string
  description = "The schedule expression for a Cloudwatch Event rule to run Lambda periodically"
}

variable "worker-role" {
  description = "The IAM Role ID for Worker of an EKS cluster"
}

variable "shared_services_account" {
  description = "The shared services account ID"
  type        = string
}
