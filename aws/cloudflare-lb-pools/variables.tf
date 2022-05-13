variable "name" {
  type        = string
  description = "Cloudflare load balancer Pool's name"
}

variable "description" {
  type        = string
  description = "The Description about cloudflare LB Pool Usage"
}

variable "pool_enable" {
  type        = bool
  description = "Used to enable/disable Pool"
}

variable "notification_email" {
  type        = string
  description = "Email address for notofication from cloudflare"
}

variable "policy" {
  type        = string
  description = "Routing Policy for traffic. like Random etc"
}


variable "region_1" {
  type        = string
  description = "Region for first origin"
}

variable "region_1_address" {
  type        = string
  description = "IP Address OR LB address to route the traffic"
}

variable "region_1_enable" {
  type        = string
  description = "Used to enable/disable traffic flow for Origin 1"
}

variable "region_1_weight" {
  type        = string
  description = "A weight of 0 means traffic will not be sent to this origin, but health is still checked. Default: 1."
}

variable "region_2" {
  type        = string
  description = "Region for second origin"
}

variable "region_2_address" {
  type        = string
  description = "IP Address OR LB address to route the traffic"
}

variable "region_2_enable" {
  type        = string
  description = "Used to enable/disable traffic flow for Origin 2"
}

variable "region_2_weight" {
  type        = string
  description = "A weight of 0 means traffic will not be sent to this origin, but health is still checked. Default: 1."
}

variable "header" {
  type        = string
  description = "Name of the header i.e Host"
}

variable "header_value" {
  type        = string
  description = "Value for the header"
}
