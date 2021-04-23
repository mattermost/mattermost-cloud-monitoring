variable "argocd_chart_version" {
  type        = string
  description = "The version of the Argo CD helm chart"
}

variable "argo_chart_values_directory" {
  type        = string
  description = "The values.yaml location which Argo CD will use"
}
