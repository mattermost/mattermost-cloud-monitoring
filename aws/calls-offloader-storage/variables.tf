variable "enabled_efs" {
  type        = bool
  description = "Whether to create an EFS file system."
  default     = false
}

variable "enabled_nfs" {
  type        = bool
  description = "Whether to create an NFS server on EC2."
  default     = false
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs where EFS mount targets or NFS server will reside."
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID for networking and security groups."
}

variable "deployment_name" {
  type        = string
  description = "The name of the deployment for resource naming conventions."
}

variable "environment" {
  type        = string
  description = "The environment for the deployment (e.g., dev, staging, prod)."
}

variable "instance_type" {
  type        = string
  description = "Instance type for the NFS server."
  default     = "t3.micro"
}

variable "ami_id" {
  type        = string
  description = "AMI ID to use for the NFS server EC2 instance."
  default     = "ami-0c55b159cbfafe1f0"
}

variable "efs_performance_mode" {
  type        = string
  description = "Performance mode for the EFS file system."
  default     = "generalPurpose"
}

variable "efs_throughput_mode" {
  type        = string
  description = "Throughput mode for the EFS file system."
  default     = "bursting"
}

variable "nfs_security_group_ingress_cidr" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access the NFS server."
  default     = ["10.0.0.0/16"] # Replace with your Kubernetes cluster CIDR
}

variable "nfs_storage_size" {
  type        = number
  description = "The size of the EBS volume in GiB for the NFS server storage."
  default     = 50
}
