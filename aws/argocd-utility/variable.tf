variable "utilities" {
  description = "The list of utilities"
  type = list(object({
    name = string
  }))
}

variable "cluster_id" {
  description = "The cluster id"
  type = string
}

variable "git_repo_url" {
  description = "The git repo url"
  type = string
}

variable "environment" {
  description = "The environment"
  type = string
}

variable "lb_certificate_arn" {
  description = "The certificate arn"
  type = string
}

variable "lb_private_certificate_arn" {
  description = "The private certificate arn"
  type = string
}

variable "vpc_id" {
  description = "The vpc id"
  type = string
}

variable "private_domain" {
  description = "The private domain"
  type = string
}

variable "ip_range" {
  description = "The ip range"
  type = string
}

variable "api_server" {
  description = "The api server"
  type = string
}

variable "ca_data" {
  description = "The ca data"
  type = string
}

variable "cluster_name" {
  description = "The cluster name"
  type = string
}

variable "argocd_role_arn" {
  description = "The argocd role arn"
  type = string
}