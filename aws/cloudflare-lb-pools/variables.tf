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
  type        = list(string)
  description = "A list of string values for the header."
}

variable "follow_redirects" {
  type        = bool
  description = "Follow redirects if returned by the origin. Only valid if type is http or https."
}

variable "expected_codes" {
  type        = string
  description = "The expected HTTP response code or code range of the health check. Eg 2xx. Only valid and required if type is http or https"
}

variable "monitor_method" {
  type        = string
  description = "The method to use for the health check. Valid values are any valid HTTP verb if type is http or https"
}

variable "timeout" {
  type        = number
  description = "The timeout (in seconds) before marking the health check as failed. Default: 5."
}

variable "interval" {
  type        = number
  description = "The interval between each health check, Shorter intervals may improve failover time, but will increase load on the origins as we check from multiple locations. Default: 60."
}

variable "retries" {
  type        = number
  description = "The number of retries to attempt in case of a timeout before marking the origin as unhealthy. Retries are attempted immediately. Default: 2."
}

variable "steering_policy" {
  type        = string
  description = "Determine which method the load balancer uses to determine the fastest route to your origin. Valid values are: 'off', 'geo', 'dynamic_latency', 'random', 'proximity'."
}

variable "proxied" {
  type        = bool
  description = "Whether the hostname gets Cloudflare's origin protection. Defaults to false."
}

variable "zone_id" {
  type        = string
  description = "The zone ID to add the load balancer to."
}

variable "lb_name" {
  type        = string
  description = "(Required) The DNS name (FQDN, including the zone) to associate with the load balancer."
}
