variable "deployment_name" {
  type        = string
  description = "The name of the deployment"
}

variable "kubeconfig_dir" {
  type        = string
  description = "The directory where the generated kubeconfig will be appended by terraform provider"
}

variable "private_hosted_zoneid" {
  type        = string
  description = "The private Hosted zone ID"
}

variable "chartmuseum_chart_values_directory" {
  type        = string
  description = "The helm values directory to be used for deployment"
}

variable "chartmuseum_bucket" {
  type        = string
  description = "The S3 bucket where we push the charts"
}

variable "chartmuseum_user_key_id" {
  type        = string
  description = "The AWS user access key ID"
}

variable "chartmuseum_user_access_key" {
  type        = string
  description = "The AWS user access key"
}

variable "chartmuseum_hostname" {
  type        = string
  description = "The dns hostname for chartmuseum"
}
