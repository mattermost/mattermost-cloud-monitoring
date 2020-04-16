variable "environment" {
  default = "dev"
  type    = string
}

variable "region" {
  default = "us-east-1"
  type    = string
}

variable "vpc_cidrs" {
  default = [""]
  type    = list(string)
}

variable "vpc_azs" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
  type    = list(string)
}

variable "transit_gateway_id" {
  default = ""
  type    = string
}

variable "transit_gtw_route_destination" {
  default     = ""
  type        = string
  description = "The destination of the transit gateway route table entry"
}
