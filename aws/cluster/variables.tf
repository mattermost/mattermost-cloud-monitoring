variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(any)
}

variable "private_subnet_ids" {
  type = list(any)
}

variable "deployment_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "max_size" {
  type = string
}

variable "min_size" {
  type = string
}

variable "desired_size" {
  type = string
}

variable "cidr_blocks" {
  type = list(string)
}

variable "environment" {
  type = string
}

variable "eks_ami_id" {
  type = string
}

variable "gitlab_cidr" {
  type = list(string)
}

variable "teleport_cidr" {
  type = list(string)
}

variable "cluster_short_name" {
  type = string
}

variable "matterwick_cluster_access_enabled" {
  type = bool
}

variable "matterwick_iam_user" {
  type = string
}

variable "matterwick_username" {
  type = string
}

variable "provider_role_arn" {
  type    = string
  default = ""
}

variable "cnc_user" {
  type = string
}

variable "log_types" {
  type = list(string)
}

variable "node_volume_size" {
  type = number
}

variable "node_volume_type" {
  type = string
}

variable "node_group_name" {
  type = string
}

variable "aws_reserved_sso_id" {
  type = string
}

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

variable "enable_ebs_csi_addon" {
  type        = bool
  description = "Whether to enable the EKS EBS CSI addon or not"
}

variable "ebs_csi_addon_version" {
  type        = string
  description = "The version of the EKS EBS CSI addon"
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

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  default     = null
  type        = bool
}

variable "availability_zones" {
  description = "List of availability zones to place the instances"
  type        = list(string)
}
