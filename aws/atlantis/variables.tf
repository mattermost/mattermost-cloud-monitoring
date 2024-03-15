variable "deployment_name" {
  type        = string
  description = "The name of the deployment name which be used for launch configuration"
}

variable "private_hosted_zoneid" {
  type        = string
  description = "The ID of the Route53 private hosted zone"
}
