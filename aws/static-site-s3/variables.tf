variable "domain_name" {
  type = string
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "folder_name" {
  type = string
  default = "src"
}
