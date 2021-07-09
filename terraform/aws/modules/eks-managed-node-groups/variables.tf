variable "vpc_security_group_ids" {
  description = "The IDs of the security groups that will be assigned to the cluster nodes"
}

variable "volume_size" {
  description = "The size of the node volumes"
}

variable "volume_type" {
  description = "The type of the node volumes. For example gp2"
}

variable "image_id" {
  description = "The AMI ID used for the nodes in the node group"
}

variable "instance_type" {
  description = "The instance type used for the nodes in the node group"
}

variable "user_data" {
  description = "User data passed in the launch template to run in instance boot"
}

variable "cluster_name" {
  description = "The name of the cluster that the node group will be assigned to"
}

variable "node_role_arn" {
  description = "The ARN of the IAM role attached to the node group"
}

variable "subnet_ids" {
  description = "A list of Subnet IDs that nodes will be deployed into"
}

variable "deployment_name" {
  description = "A phrase that can be used for tagging tha identifies the deployment"
}

variable "desired_size" {
  description = "The desired number of nodes in the node group"
}

variable "max_size" {
  description = "The maximum number of nodes in the node group"
}

variable "min_size" {
  description = "The minimum number of nodes in the node group"
}

variable "node_group_name" {
  description = "A name that can be used to identify the node group"
}

variable "cluster_short_name" {
  description = "A short name that identifies the cluster"
}
