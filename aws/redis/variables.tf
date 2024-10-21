variable "name" {
  description = "The name of the ElastiCache Redis cluster"
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
  description = "Number of cache nodes in the Redis cluster"
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
