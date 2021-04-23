variable "deployment_name" {
  type        = string
  description = "The name of the deployment name which be used for launch configuration"
}

variable "kubeconfig_dir" {
  type        = string
  description = "The directory where the generated kubeconfig will be appended by terraform provider"
}

variable "environment" {
  type        = string
  description = "The name of the environment which will deploy to and will be added as a tag"
}

variable "cluster_name" {
  type        = string
  description = "The name of the kubernetes cluster"
}

variable "teleport_chart_version" {
  type        = string
  description = "The helm chart version for teleport"
}
