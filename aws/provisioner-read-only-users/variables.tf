variable "environment" {
  type        = string
  description = "The name of the environment is created"
}

variable "deployment_name" {
  type        = string
  description = "The name of the deployment which exists in"
}

variable "provisioner_users" {
  type        = list(string)
  description = "The list defined the users can use provisioner"
}
