variable "clusters" {
  type = list(object({
    cluster_name    = string
    cluster_version = string
    vpc_id          = string
    node_groups     = any
  }))
  default = [
    {
      cluster_name    = "myekscluster1"
      cluster_version = "1.29"
      vpc_id          = "vpc-id"
      node_groups = {
        #https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2236
        # versioning node group name is necessary due to this issue above
        workspaces-v1 = {
          min_size       = 2
          max_size       = 8
          desired_size   = 2
          instance_types = ["m5.large"]
          ami_id         = "ami-id"
          taints         = {}
        },
        calls-v1 = {
          min_size       = 1
          max_size       = 8
          desired_size   = 1
          instance_types = ["m5.large"]
          ami_id         = "ami-id"
          taints = {
            "calls" = {
              key    = "calls-offloader"
              value  = "true"
              effect = "NO_SCHEDULE"
            }
          }
        },
        monitoring-v1 = {
          min_size       = 1
          max_size       = 10
          desired_size   = 2
          instance_types = ["m5.large"]
          ami_id         = "ami-id"
          taints = {
            "monitoring" = {
              key    = "monitoring"
              value  = "true"
              effect = "NO_SCHEDULE"
            }
          }
        }
      }
    },
    {
      cluster_name    = "myekscluster2"
      cluster_version = "1.29"
      vpc_id          = "vpc-id"
      node_groups = {
        #https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2236
        # versioning node group name is necessary due to this issue above
        workspaces-v1 = {
          min_size       = 2
          max_size       = 8
          desired_size   = 4
          instance_types = ["m5.large"]
          ami_id         = "ami-id"
          taints         = {}
        },
        calls-v1 = {
          min_size       = 1
          max_size       = 8
          desired_size   = 1
          instance_types = ["m5.large"]
          ami_id         = "ami-id"
          taints = {
            "calls" = {
              key    = "calls-offloader"
              value  = "true"
              effect = "NO_SCHEDULE"
            }
          }
        },
        monitoring-v1 = {
          min_size       = 1
          max_size       = 10
          desired_size   = 2
          instance_types = ["m5.large"]
          ami_id         = "ami-id"
          taints = {
            "monitoring" = {
              key    = "monitoring"
              value  = "true"
              effect = "NO_SCHEDULE"
            }
          }
        }
      }
    }
  ]
}

variable "utilities" {
  description = "The list of utilities"
  type = list(object({
    name        = string
    enable_irsa = bool
    internal_dns = object({
      enabled  = bool
      dns_name = list(string)
    })
    service_account    = string
    cluster_label_type = string
  }))
  default = [
    {
      name        = "pgbouncer"
      enable_irsa = false
      internal_dns = {
        enabled  = false
        dns_name = []
      }
      service_account    = "pgbouncer"
      cluster_label_type = ""
    },
    {
      name        = "nginx"
      enable_irsa = false
      internal_dns = {
        enabled  = false
        dns_name = []
      }
      service_account    = "nginx"
      cluster_label_type = ""
    },
    {
      name        = "nginx-internal"
      enable_irsa = false
      internal_dns = {
        enabled  = false
        dns_name = []
      }
      service_account    = "nginx-internal"
      cluster_label_type = ""
    },
    {
      name        = "prometheus-operator"
      enable_irsa = false
      internal_dns = {
        enabled  = true
        dns_name = ["prometheus"]
      }
      service_account    = "prometheus-operator"
      cluster_label_type = ""
    },
    {
      name        = "thanos"
      enable_irsa = false
      internal_dns = {
        enabled  = true
        dns_name = ["thanos", "grpc.thanos"]
      }
      service_account    = "thanos"
      cluster_label_type = ""
    },
    {
      name        = "teleport"
      enable_irsa = false
      internal_dns = {
        enabled  = false
        dns_name = []
      }
      service_account    = "teleport"
      cluster_label_type = ""
    },
    {
      name        = "alloy"
      enable_irsa = false
      internal_dns = {
        enabled  = false
        dns_name = []
      }
      service_account    = "alloy"
      cluster_label_type = ""
    },
    {
      name        = "velero"
      enable_irsa = true
      internal_dns = {
        enabled  = false
        dns_name = []
      }
      service_account    = "velero-server"
      cluster_label_type = ""
    },
    {
      name        = "bifrost"
      enable_irsa = true
      internal_dns = {
        enabled  = false
        dns_name = []
      }
      service_account    = "bifrost"
      cluster_label_type = "customer"
    }
  ]
}

########################### Generic ################################
variable "region" {
  default = "us-east-1"
  type    = string
}

variable "environment" {
  default = "dev"
  type    = string
}

variable "cluster_endpoint_public_access" {
  type    = bool
  default = false
}

variable "cluster_endpoint_private_access" {
  type    = bool
  default = true
}

variable "cloud_provisioning_node_policy_arn" {
  type    = string
  default = "<cloud-provisioning-node-policy-arn>"
}

variable "coredns_version" {
  type    = string
  default = "v1.11.1-eksbuild.9"
}

variable "kube_proxy_version" {
  type    = string
  default = "v1.29.3-eksbuild.5"
}

variable "ebs_csi_driver_version" {
  type    = string
  default = "v1.31.0-eksbuild.1"
}

variable "snapshot_controller_version" {
  type    = string
  default = "v8.0.0-eksbuild.1"
}

variable "calico_operator_version" {
  type    = string
  default = "v3.28.0"
}

variable "cluster_security_group_additional_rules" {
  default = {
    rule1 = {
      description = "Additional rule description"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["172.0.0.0/24", "192.168.0.0/24"]
      type        = "ingress"
    }
  }
}

variable "cluster_enabled_log_types" {
  default = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
}

variable "argocd_role_arn" {
  description = "The argocd role arn"
  type        = string
  default     = "<argocd-role-arn>"
}

variable "argocd_server" {
  description = "The argocd server"
  type        = string
  default     = "<argocd-server>"
}

variable "staff_role_arn" {
  description = "The staff role arn"
  type        = string
  default     = "<staff-role-arn>"
}

variable "provisioner_role_arn" {
  description = "The provisioner role arn"
  type        = string
  default     = "<provisioner-role-arn>"
}

variable "allow_list_cidr_range" {
  description = "The list of CIDRs to allow communication with the private ingress."
  type        = string
  default     = "0.0.0.0/0"
}

variable "gitops_repo_url" {
  description = "The git repo url"
  type        = string
  default     = "git.example.com"
}

variable "gitops_repo_path" {
  description = "The git repo path"
  type        = string
  default     = "cloud/example/gitops.git"
}

variable "gitops_repo_username" {
  description = "The git repo username for executing git commands"
  type        = string
  default     = "<git-repo-username>"
}

variable "lb_certificate_arn" {
  description = "The certificate arn"
  type        = string
  default     = "<certificate-arn>"
}

variable "lb_private_certificate_arn" {
  description = "The private certificate arn"
  type        = string
  default     = "<private-certificate-arn>"
}
