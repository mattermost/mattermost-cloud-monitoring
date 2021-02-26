variable "environment" {}

variable "vpn_cidr" {}

variable "vpc_id" {}

variable "private_subnet_ids" {}

variable "es_instance_type" {}

variable "es_volume_size" {}

variable "instance_count" {}

variable "dedicated_master_enabled" {}

variable "dedicated_master_count" {}

variable "dedicated_master_type" {}

variable "es_zone_awareness" {}

variable "es_zone_awareness_count" {}

variable "domain_name" {}

variable "es_version" {}

variable "private_hosted_zoneid" {}

variable "cw_retention_in_days" {
  type    = string
  default = "90"
}
