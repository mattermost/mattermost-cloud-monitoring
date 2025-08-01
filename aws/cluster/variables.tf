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

variable "argocd_account_role" {
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

variable "aws_read_only_sso_role_name" {
  default     = ""
  type        = string
  description = "Name of the read only SSO iam role"
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

variable "enable_spot_nodes" {
  description = "If true, spot nodes will be created"
  default     = false
  type        = bool
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

variable "map_subnets" {
  description = "Map of availability zones and their subnets"
  type        = map(any)
}

variable "atlantis_user" {
  description = "The atlantis user used for IaC"
  type        = string
}

variable "is_gp3_default" {
  description = "Set to true to set gp3 storageClass as default"
  type        = string
  default     = "true"
}

variable "storage_class_volume_type" {
  description = "Type of volume"
  type        = string
  default     = "gp3"
}

variable "eks_arm_image_id" {
  type        = string
  description = "The AMI ID used for the arm nodes in the node group"
}

variable "arm_instance_type" {
  type        = string
  description = "The instance type used for the arm nodes in the node group"
}

variable "arm_desired_size" {
  type        = string
  description = "The desired number of arm nodes in the node group"
}

variable "arm_max_size" {
  type        = string
  description = "The maximum number of arm nodes in the node group"
}

variable "arm_min_size" {
  type        = string
  description = "The minimum number of arm nodes in the node group"
}

variable "use_al2023" {
  description = "Enable AL2023-specific configurations. Defaults to false for AL2."
  type        = bool
  default     = false
}

variable "al2023_ami_id" {
  description = "The AMI ID for AL2023 nodes"
  type        = string
  default     = ""
}

variable "al2023_arm_image_id" {
  description = "The AMI ID for ARM64 nodes using AL2023"
  type        = string
  default     = ""
}

variable "is_calico_enabled" {
  type    = bool
  default = false
}

variable "calico_desired_size" {
  description = "Desired size for the Calico node group"
  type        = number
  default     = 3
}

variable "calico_min_size" {
  description = "Minimum size for the Calico node group"
  type        = number
  default     = 2
}

variable "calico_max_size" {
  description = "Maximum size for the Calico node group"
  type        = number
  default     = 5
}

variable "calico_max_pods" {
  description = "Maximum number of pods when Calico CNI is enabled"
  type        = number
  default     = 110
}

variable "pause_container_image" {
  description = "The pause container image to use for the node group"
  type        = string
  default     = "602401143452.dkr.ecr.us-east-1.amazonaws.com/eks/pause:3.5"
}
