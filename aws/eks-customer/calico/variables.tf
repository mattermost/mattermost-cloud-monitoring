variable "cluster_endpoint" {
    description = "The endpoint for the EKS cluster"
    type        = string
}

variable "cluster_certificate_authority_data" {
    description = "The certificate-authority-data for the EKS cluster"
    type        = string
}

variable "cluster_name" {
    description = "The name of the EKS cluster"
    type        = string
}

variable "calico_operator_version" {
  description = "The version of the Calico operator"
  type = string
}

variable "cluster_arn" {
  description = "The ARN of the EKS cluster"
  type        = string
}

variable "region" {
  description = "The region for the EKS cluster"
  type        = string
  default     = "us-east-1"
}