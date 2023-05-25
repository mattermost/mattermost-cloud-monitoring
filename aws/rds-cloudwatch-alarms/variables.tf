variable "cluster_instance_identifier" {
  type        = string
  description = "The rds aurora cluster identifier to set the alerm name"
  default     = ""
}

variable "db_instance_identifier" {
  type        = string
  description = "The rds database identifier to set the alerm name"
}

variable "instance_type" {
  type        = string
  description = "The rds database instance type to calculate the alarm limits"
}

variable "sns_topic" {
  type        = string
  description = "The sns topic name to sent cloudwatch alarms"
}

variable "ram_memory_bytes" {
  default = {
    "db.t3.small"     = "2147483648"
    "db.t3.medium"    = "4294967296"
    "db.t3.large"     = "8589934592"
    "db.t4g.small"    = "2147483648"
    "db.t4g.medium"   = "4294967296"
    "db.t4g.large"    = "8589934592"
    "db.r5.large"     = "17179869184"
    "db.r5.xlarge"    = "34359738368"
    "db.r5.2xlarge"   = "68719476736"
    "db.r5.4xlarge"   = "137438953472"
    "db.r5.8xlarge"   = "274877906944"
    "db.r5.12xlarge"  = "412316860416"
    "db.r5.16xlarge"  = "549755813888"
    "db.r5.24xlarge"  = "824633720832"
    "db.m6g.large"    = "8589934592"
    "db.r6g.large"    = "17179869184"
    "db.r6g.xlarge"   = "34359738368"
    "db.r6g.2xlarge"  = "68719476736"
    "db.r6g.4xlarge"  = "137438953472"
    "db.r6g.8xlarge"  = "274877906944"
    "db.r6g.12xlarge" = "412316860416"
    "db.r6g.16xlarge" = "549755813888"
    "db.r6g.24xlarge" = "824633720832"
  }
  type        = map(any)
  description = "The RAM memory of each instance type in Bytes."
}

variable "memory_alarm_limit" {
  default     = "100000000"
  description = "Limit to trigger memory alarm. Number in Bytes (100MB)"
  type        = string
}

variable "memory_cache_proportion" {
  default     = 0.75
  description = "Proportion of memory that is used for cache. By default it is 75%."
  type        = number
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
