variable "prometheus_operator_chart_version" {
  type        = string
  description = "The helm chart version which will be deployed"
}

variable "private_hosted_zoneid" {
  type        = string
  description = "The ID of the Route53 private hosted zone"
}

