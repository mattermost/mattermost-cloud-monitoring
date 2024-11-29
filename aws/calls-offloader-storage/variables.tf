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

variable "vpc_configurations" {
  type = map(object({
    vpc_id     = string
    subnet_ids = list(string)
  }))
  description = "Map of VPC configurations, including VPC ID and subnets."
}

variable "environment" {
  type        = string
  description = "The environment for the deployment (e.g., dev, staging, prod)."
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

variable "ami_id" {
  type        = string
  description = "AMI ID to use for the NFS server EC2 instance."
  default     = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  type        = string
  description = "Instance type for the NFS server."
  default     = "t3.micro"
}

variable "nfs_storage_size" {
  type        = number
  description = "The size of the EBS volume in GiB for the NFS server storage."
  default     = 50
}

variable "efs_encrypted" {
  type        = bool
  description = "If true, the disk will be encrypted."
  default     = true
}

variable "efs_kms_key_id" {
  type        = string
  description = "Optional KMS Key ID for encrypting the EFS file system. Leave empty to use the default AWS-managed KMS key."
  default     = ""
}

variable "nfs_encrypted" {
  type        = bool
  description = "If true, the EBS volume will be encrypted."
  default     = true
}

variable "nfs_kms_key_id" {
  type        = string
  description = "Optional KMS Key ID for encrypting the NFS EBS storage. Leave empty to use the default AWS-managed KMS key."
  default     = ""
}

variable "volume_type" {
  type        = string
  description = "Type of volumefor the NFS server."
  default     = "gp3"
}

variable "root_volume_size" {
  type        = number
  description = "Size of the root volume in GiB for the NFS server."
  default     = 20
}

variable "root_kms_key_id" {
  type        = string
  description = "Optional KMS Key ID for encrypting the root volume of the NFS server. Leave empty to use the default AWS-managed KMS key."
  default     = ""
}

variable "detailed_monitoring" {
  type        = bool
  description = "If true, the detailed_monitoring will be enabled."
  default     = true
}
