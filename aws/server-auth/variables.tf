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

variable "api_gateway_vpc_endpoints" {}

variable "environment" {
  type        = list(string)
  description = "VPC endpoints of VPCs which are used in the policy of the rest API gateway"
}
