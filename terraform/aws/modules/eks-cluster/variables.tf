variable "vpc_id" {}

variable "public_subnet_ids" {}

variable "private_subnet_ids" {}

variable "deployment_name" {}

variable "instance_type" {}

variable "max_size" {}

variable "min_size" {}

variable "desired_size" {}

variable "cidr_blocks" {}

variable "kubeconfig_dir" {}

variable "volume_size" {}

variable "environment" {}

variable "region" {}

variable "eks_ami_id" {}

variable "key_name" {}

variable "teleport_cidr" {}

variable "worker_private_subnet_ids" {}

variable "cluster_short_name" {}

variable "log_types" {}

variable "node_volume_size" {}

variable "node_volume_type" {}

variable "node_group_name" {}

variable "aws_reserved_sso_id" {}

variable "enable_vpc_cni_addon" {
  type        = bool
  description = "Whether to enable the EKS AWS CNI addon or not"
}

variable "vpc_cni_addon_version" {
  type        = string
  description = "The version of the EKS VPC CNI addon"
}

variable "enable_coredns_addon" {
  type        = bool
  description = "Whether to enable the EKS CoreDNS addon or not"
}

variable "coredns_addon_version" {
  type        = string
  description = "The version of the EKS CoreDNS addon"
}

variable "enable_kube_proxy_addon" {
  type        = bool
  description = "Whether to enable the EKS Kube Proxy addon or not"
}

variable "kube_proxy_addon_version" {
  type        = string
  description = "The version of the EKS Kube Proxy addon"
}
