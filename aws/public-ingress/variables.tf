variable "deployment_name" {
  type        = string
  description = "The name of the deployment name which be used for EKS cluster"
}

variable "kubeconfig_dir" {
  type        = string
  description = "The directory where the generated kubeconfig will be appended by terraform provider"
}

variable "nginx_chart_values_directory" {
  type        = string
  description = "The directory where the helm values are located."
}
