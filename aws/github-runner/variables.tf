# Variable for Secrets suffix
variable "secrets_suffix" {
  description = "Suffix for the secrets ARNs (e.g., GitHubSecret-*)"
  type        = string
  default     = "*"
}
