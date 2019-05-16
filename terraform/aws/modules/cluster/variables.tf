variable "vpc_id" {}

variable "subnet_ids" {
    type = "list"
}

variable "deployment_name" {}

variable "instance_type" {}

variable "max_size" {}

variable "min_size" {}

variable "desired_capacity" {}

variable "cidr_blocks" {
    type = "list"
}

variable "kubeconfig_dir" {}
