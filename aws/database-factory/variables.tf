variable "environment" {
  type        = string
  description = "The environment will be created"
}

variable "deployment_name" {
  type        = string
  description = "The name of the deployment"
}

variable "database_factory_users" {
  type        = list(string)
  description = "The users to attach the IAM policies"
}
