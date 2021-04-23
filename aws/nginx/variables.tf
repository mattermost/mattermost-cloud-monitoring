variable "public_domain_certificate" {
  type        = string
  description = "The domain name for the ACM certificate for a public hosted zone"
}

variable "private_domain_certificate" {
  type        = string
  description = "The domain name for the ACM certificate for a private hosted zone"
}

variable "nginx_chart_version" {
  type        = string
  description = "The helm chart version to deploy for Nginx"
}

