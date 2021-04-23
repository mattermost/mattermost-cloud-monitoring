variable "deployment_name" {
  type        = string
  description = "The name of the deployment of the EKS cluster to use data resource"
}

variable "kubeconfig_dir" {
  type        = string
  description = "The directory where the generated kubeconfig will be appended by terraform provider"
}

variable "private_hosted_zoneid" {
  type        = string
  description = "The ID of the Route53 private hosted zone"
}

