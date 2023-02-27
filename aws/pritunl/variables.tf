variable "name" {
  type = string
}

variable "domain" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "mongodb_uri" {
  type = string
}

variable "instance_type_for_lt" {
  type = string
}

variable "public_hosted_zoneid" {
  type = string
}

variable "ubuntu_account_number" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "pritunl_app_count" {
  type = string
}

variable "volume_size" {
  type = string
}

variable "fixed_eni" {
  type = list(any)
}

variable "az_list" {
  type = list(any)
}
