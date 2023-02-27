variable "environment" {
  type        = string
  description = "The environment name like staging, staging-dr, prod etc where we want to setup resources"
  default     = "test"
}

variable "deployment_name" {
  type        = string
  description = "The name of the deployment"
  default     = "test"
}

variable "vpc_id" {
  type        = string
  description = "The vpc id which host the cluster & access the bucket"
  default     = "test-vpc"
}

variable "tags" {
  description = "Tags for bucket & cost calculation"
  type        = map(string)
  default     = {}
}
