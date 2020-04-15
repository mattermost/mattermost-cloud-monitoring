variable "region" {
  default = "us-east-1"
  type    = "string"
}

variable "environment" {
  default = "staging"
  type    = "string"
}

variable "vpc_id" {
  default = ""
  type    = "string"

}

variable "private_subnet_ids" {
  type    = list(string)
  default = [""]
}

variable "vpn_cidr" {
  default     = ""
  type        = "string"
  description = "Without /32 as it is used in the resource policy"
}

variable "mattermost_network" {
  default = [""]
  type    = list(string)
}

variable "es_instance_type" {
  type    = "string"
  default = "m4.xlarge.elasticsearch"
}

variable "es_volume_size" {
  type    = "string"
  default = "100"
}

variable "instance_count" {
  type    = "string"
  default = "2"
}

variable "dedicated_master_type" {
  type    = "string"
  default = "false"
}

variable "dedicated_master_threshold" {
  type    = "string"
  default = "0" #Not used unless dedicated_master_type set to true
}

variable "es_zone_awareness" {
  type    = bool
  default = true
}

variable "es_zone_awareness_count" {
  type    = "string"
  default = "2" #Not used unless awareness set to true
}

variable "es_version" {
  type    = "string"
  default = "7.1"
}

variable "private_hosted_zoneid" {
  default = ""
  type    = "string"
}
