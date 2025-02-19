variable "vpc_security_group_ids" {
  type        = list(string)
  description = "The IDs of the security groups that will be assigned to the cluster nodes"
}

variable "volume_size" {
  type        = string
  description = "The size of the node volumes"
}

variable "volume_type" {
  type        = string
  description = "The type of the node volumes. For example gp2"
}

variable "image_id" {
  type        = string
  description = "The AMI ID used for the nodes in the node group"
}

variable "instance_type" {
  type        = string
  description = "The instance type used for the nodes in the node group"
}

variable "user_data" {
  type        = string
  description = "User data passed in the launch template to run in instance boot"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster that the node group will be assigned to"
}

variable "node_role_arn" {
  type        = string
  description = "The ARN of the IAM role attached to the node group"
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of Subnet IDs that nodes will be deployed into"
}

variable "deployment_name" {
  type        = string
  description = "A phrase that can be used for tagging tha identifies the deployment"
}

variable "desired_size" {
  type        = string
  description = "The desired number of nodes in the node group"
}

variable "max_size" {
  type        = string
  description = "The maximum number of nodes in the node group"
}

variable "min_size" {
  type        = string
  description = "The minimum number of nodes in the node group"
}

variable "node_group_name" {
  type        = string
  description = "A name that can be used to identify the node group"
}

variable "cluster_short_name" {
  type        = string
  description = "A short name that identifies the cluster"
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

variable "subnets" {
  description = "Map of availability zones and their subnets"
  type        = map(any)
}

variable "vpc_id" {
  description = "VPC ID to use for the EKS cluster"
  type        = string
}

variable "arm_image_id" {
  type        = string
  description = "The AMI ID used for the nodes in the node group"
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

variable "api_server_endpoint" {
  description = "The API server endpoint for the EKS cluster"
  type        = string
}

variable "certificate_authority" {
  description = "The certificate authority data for the EKS cluster"
  type        = string
}

variable "service_ipv4_cidr" {
  description = "The service IPv4 CIDR range for the EKS cluster"
  type        = string
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
