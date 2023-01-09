variable "provisioner_read_only_users" {
  type    = list(string)
  default = ["example-user-read-ony-dev"]
}

variable "environment" {
  default = "dev"
  type    = string
}

variable "deployment_name" {
  default = "deployment-example"
  type    = string
}