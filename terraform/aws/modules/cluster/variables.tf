variable "vpc_id" {}

variable "public_subnet_ids" {}

variable "private_subnet_ids" {}

variable "deployment_name" {}

variable "instance_type" {}

variable "max_size" {}

variable "min_size" {}

variable "desired_capacity" {}

variable "cidr_blocks" {}

variable "kubeconfig_dir" {}

variable "volume_size" {}

variable "environment" {}

variable "eks_ami_id" {}

variable "key_name" {}

variable "teleport_cidr" {}

variable "cluster_short_name" {}

variable "matterwick_cluster_access_enabled" {}

variable "matterwick_iam_user" {}

variable "matterwick_username" {}

variable "provider_role_arn" {
  type    = string
  default = ""
}
