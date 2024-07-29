variable "cluster_id" {
  description = "The id of the EKS cluster"
  type = string
}

variable "region" {
  description = "The region for the EKS cluster"
  type = string
  default = "us-east-1"
}

variable "environment" {
  description = "The environment"
  type = string
  default = "dev"
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

variable cluster_security_group_tags {
  description = "The tags for the security group"
  type = map(string)
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
  type = map(object({
    name = string
    min_size     = number
    max_size     = number
    desired_size = number
  }))
}

variable "utilities" {
  description = "The list of utilities"
  type = list(object({
    name = string
  }))
  default = [
    {
      name = "pgbouncer"
    },
    {
    	name = "nginx"
    },
    {
    	name = "nginx-internal"
    },
    {
    	name = "prometheus-operator"
    },
    {
      name = "thanos"
    },
    {
      name = "teleport"
    },
    {
      name = "promtail"
    },
    {
      name = "velero"
    }
  ]
}

variable "git_repo_url" {
  description = "The git repo url"
  type = string
  default = "git@git.internal.mattermost.com:cloud-sre/kubernetes-workloads/gitops-sre.git"
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

variable "ip_range" {
  description = "The ip range"
  type = string
}
