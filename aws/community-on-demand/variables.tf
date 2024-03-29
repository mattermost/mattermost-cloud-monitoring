variable "deployment_name" {
  type        = string
  description = "The name of the deployment"
}

variable "vpc_id" {
  type        = string
  description = "The vpc id which host the cluster & access the bucket"
}

variable "tags" {
  description = "Tags for bucket & cost calculation"
  type        = map(string)
  default     = {}
}
