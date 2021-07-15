variable "environment" {}

variable "provisioner_users" {}

variable "cnc_user" {}

variable "force_destroy_state_bucket" {
  type    = bool
  default = false
}

variable "force_destroy_stackrox_bundle_bucket" {
  type    = bool
  default = false
}
