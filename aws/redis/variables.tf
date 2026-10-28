variable "name" {
  description = "Base name for the subnet group, security group and (by default) the replication group"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "redis_version" {
  description = "The Redis version to use"
  type        = string
  default     = "7.1"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Redis cluster"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID where the ElastiCache Redis will be deployed"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the Redis nodes"
  type        = string
  default     = "cache.t2.micro"
}

variable "num_cache_nodes" {
  description = "Number of cache clusters (nodes) in the replication group. Failover is disabled, so extra nodes are read replicas only"
  type        = number
  default     = 1
}

variable "port" {
  description = "Port for Redis"
  type        = number
  default     = 6379
}

variable "allowed_cidrs" {
  description = "CIDR blocks allowed to access the Redis cluster"
  type        = list(string)
}

variable "maintenance_window" {
  description = "Weekly maintenance window, e.g. sun:05:00-sun:06:00 (UTC). Leave null to keep the AWS-assigned window"
  type        = string
  default     = null
}

variable "tags" {
  description = "Extra tags for all resources"
  type        = map(string)
  default     = {}
}

variable "replication_group_id" {
  description = "Replication group ID. Defaults to var.name; set it when importing an existing group with a different ID"
  type        = string
  default     = null
}

variable "description" {
  description = "Replication group description"
  type        = string
  default     = "Mattermost Redis, managed by Terraform"
}

variable "parameter_group_name" {
  description = "Custom cache parameter group name. Leave null to use the engine default (default.redis7)"
  type        = string
  default     = null
}

variable "transit_encryption_enabled" {
  description = "Enable TLS in transit"
  type        = bool
  default     = true
}

variable "transit_encryption_mode" {
  description = "TLS mode when transit encryption is enabled: preferred accepts both plaintext and TLS clients, required accepts TLS only"
  type        = string
  default     = "preferred"

  validation {
    condition     = contains(["preferred", "required"], var.transit_encryption_mode)
    error_message = "transit_encryption_mode must be preferred or required."
  }
}
