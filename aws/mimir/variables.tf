variable "environment" {
  type        = string
  description = "The cloud environment: dev, test, staging, or prod."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where MSK and Mimir resources will be created."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for MSK cluster placement (minimum 2 AZs required)."
}

variable "eks_node_security_group_id" {
  type        = string
  description = "Security group ID of EKS worker nodes that need to access MSK."
}

variable "enable_msk" {
  type        = bool
  description = "Whether to deploy the MSK Serverless cluster for Mimir ingest storage."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources."
  default     = {}
}
