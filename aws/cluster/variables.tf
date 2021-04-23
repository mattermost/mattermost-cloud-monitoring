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

variable "eks_ami_id" {}

variable "key_name" {}

variable "gitlab_cidr" {}

variable "teleport_cidr" {}

variable "cluster_short_name" {}

variable "matterwick_cluster_access_enabled" {}

variable "matterwick_iam_user" {}

variable "matterwick_username" {}

variable "provider_role_arn" {
  type    = string
  default = ""
}

variable "cnc_user" {}

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

variable "spot_desired_size" {
  description = "The desired number of nodes in the spot node group"
  default     = 0
  type        = number
}

variable "spot_instance_type" {
  description = "The instance type used for the nodes in the spot node group"
  type        = string
}

variable "spot_max_size" {
  description = "The maximum number of nodes in the spot node group"
  default     = 1
  type        = number
}

variable "spot_min_size" {
  description = "The minimum number of nodes in the spot node group"
  default     = 0
  type        = number
}
