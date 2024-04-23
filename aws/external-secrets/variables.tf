variable "environment" {
  type        = string
  description = "The name of the environment which will deploy to and will be added as a tag"
}

variable "open_oidc_provider_url" {
  type        = string
  description = "The Open OIDC Provider URL for a specific cluster"
}

variable "open_oidc_provider_arn" {
  type        = string
  description = "The Open OIDC Provider ARN for a specific cluster"
}

variable "serviceaccount" {
  type        = string
  description = "Service Account, with which we want to associate IAM permission"
}

variable "namespace" {
  type        = string
  description = "The namespace, which host the service account & target application "
}

variable "applications" {
  description = "A list of application names for which to create AWS Secrets Manager secrets."
  type        = list(string)
}

