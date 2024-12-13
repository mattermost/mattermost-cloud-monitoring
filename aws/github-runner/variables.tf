# Variable for Secrets suffix
variable "secrets_suffix" {
  description = "Suffix for the secrets ARNs (e.g., GitHubSecret-*)"
  type        = string
  default     = "*"
}

variable "service_account_role_arn" {
  description = "The service account role that will be able to assume this role"
  type        = string
}
