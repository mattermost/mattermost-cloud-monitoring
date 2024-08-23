variable "region" {
  description = "The region for the EKS cluster"
  type = string
  default = "us-east-1"
}

variable "environment" {
  description = "The environment"
  type = string
}

variable "cluster_name" {
  description = "The cluster name"
  type = string  
}

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster"
  type = string
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type = bool
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  type = bool
}

variable "vpc_id" {
  description = "The VPC ID for the EKS cluster"
  type = string
}

variable "calico_operator_version" {
  description = "The version of the Calico operator"
  type = string
}

variable cluster_security_group_additional_rules {
  description = "The list of additional security group rules for the EKS cluster"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    type        = string
  }))
}

variable cluster_enabled_log_types {
  description = "The list of log types to enable"
  type = list(string)
}

variable "coredns_version" {
  description = "The version of the CoreDNS addon"
  type = string
}

variable "kube_proxy_version" {
  description = "The version of the kube-proxy addon"
  type = string
}

variable "ebs_csi_driver_version" {
  description = "The version of the EBS CSI driver addon"
  type = string
}

variable "snapshot_controller_version" {
  type = string
}

variable "node_groups" {
  description = "The list of node groups"
  type = any
  default = {}
}

variable "cloud_provisioning_node_policy_arn" {
  description = "The cloud provisioning node policy arn"
  type = string
}

variable "utilities" {
  description = "The list of utilities"
  type = list(object({
    name = string
    enable_irsa = bool
    service_account = string
    cluster_label_type = string
  }))
}

variable "gitops_repo_url" {
  description = "The git repo url"
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

variable "argocd_role_arn" {
  description = "The argocd role arn"
  type = string
}

variable "staff_role_arn" {
  description = "The staff role arn"
  type = string
}

variable "allow_list_cidr_range" {
  description = "The list of CIDRs to allow communication with the private ingress."
  type = string
}

variable "private_domain" {
  description = "The private domain"
  type = string
}

variable "subnet_ids" {
  description = "The list of subnet IDs for the EKS cluster"
  type = list(string)
  default = []
}

variable "create_node_security_group" {
  description = "Indicates whether or not to create a security group for the EKS nodes"
  type = bool
  default = false
}

variable "create_cluster_security_group" {
  description = "Indicates whether or not to create a security group for the EKS cluster"
  type = bool
  default = true
}

variable "cluster_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
