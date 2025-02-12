variable "region" {
  description = "The region for the EKS cluster"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "The environment"
  type        = string
}

variable "cluster_name" {
  description = "The cluster name"
  type        = string
}

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster"
  type        = string
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  type        = bool
}

variable "vpc_id" {
  description = "The VPC ID for the EKS cluster"
  type        = string
}

variable "calico_operator_version" {
  description = "The version of the Calico operator"
  type        = string
}

variable "cluster_security_group_additional_rules" {
  description = "The list of additional security group rules for the EKS cluster"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    type        = string
  }))
}

variable "cluster_enabled_log_types" {
  description = "The list of log types to enable"
  type        = list(string)
}

variable "coredns_version" {
  description = "The version of the CoreDNS addon"
  type        = string
}

variable "kube_proxy_version" {
  description = "The version of the kube-proxy addon"
  type        = string
}

variable "ebs_csi_driver_version" {
  description = "The version of the EBS CSI driver addon"
  type        = string
}

variable "efs_csi_driver_version" {
  description = "The version of the EFS CSI driver addon"
  type        = string
}

variable "snapshot_controller_version" {
  type = string
}

variable "node_groups" {
  description = "The list of node groups"
  type        = any
  default     = {}
}

# variable "cloud_provisioning_node_policy_arn" {
#   description = "The cloud provisioning node policy arn"
#   type        = string
# }

# variable "cloud_provisioning_ec2_policy_arn" {
#   description = "The cloud provisioning ec2 policy arn to perform ec2 volume operations"
#   type        = string
# }

variable "utilities" {
  description = "The list of utilities"
  type = list(object({
    name                      = string
    enable_irsa               = bool
    internal_dns              = any
    namespace_service_account = string
    cluster_label_type        = string
  }))
}

variable "github_app_pem_key_path" {
  description = "The path of the Github App PEM"
  type        = string
}

variable "github_app_id" {
  description = "The app id for the Github App"
  type        = string
}

variable "github_app_installation_id" {
  description = "The installation id for the Github App"
  type        = string
}

variable "gitops_repo_url" {
  description = "The git repo url"
  type        = string
}

variable "gitops_repo_path" {
  description = "The git repo url"
  type        = string
}

variable "gitops_repo_username" {
  description = "The git repo username for executing git commands"
  type        = string
}

variable "gitops_repo_email" {
  description = "The git repo email for executing git commands"
  type        = string
}

variable "lb_certificate_arn" {
  description = "The certificate arn"
  type        = string
}

variable "lb_private_certificate_arn" {
  description = "The private certificate arn"
  type        = string
}

variable "argocd_role_arn" {
  description = "The argocd role arn"
  type        = string
}

variable "argocd_server" {
  description = "The argocd server"
  type        = string
}

variable "staff_role_arn" {
  description = "The staff role arn"
  type        = string
}

variable "provisioner_role_arn" {
  description = "The provisioner role arn"
  type        = string
}

variable "atlantis_user_arn" {
  description = "The atlantis user arn"
  type        = string
}

variable "allow_list_cidr_range" {
  description = "The list of CIDRs to allow communication with the private ingress."
  type        = string
}

variable "private_domain" {
  description = "The private domain"
  type        = string
}

variable "create_node_security_group" {
  description = "Indicates whether or not to create a security group for the EKS nodes"
  type        = bool
  default     = false
}

variable "create_cluster_security_group" {
  description = "Indicates whether or not to create a security group for the EKS cluster"
  type        = bool
  default     = true
}

variable "cluster_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "enable_auto_mode_custom_tags" {
  description = "Indicates whether or not to enable auto mode custom tags"
  type        = bool
  default     = false
}

variable "create_iam_role" {
  description = "Determines whether an IAM role is created or to use an existing IAM role"
  type        = bool
  default     = true
}

variable "create_kms_key" {
  description = "Controls if a KMS key for cluster encryption should be created"
  type        = bool
  default     = false
}

variable "attach_cluster_encryption_policy" {
  description = "Indicates whether or not to attach an additional policy for the cluster IAM role to utilize the encryption key provided"
  type        = bool
  default     = false
}

variable "cluster_encryption_config" {
  description = "Configuration block with encryption configuration for the cluster. To disable secret encryption, set this value to `{}`"
  type        = any
  default     = {}
}

variable "eks_cluster_admin_policy_arn" {
  description = "The ARN of the AmazonEKSClusterAdminPolicy"
  type        = string
  default     = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

variable "wait_for_cluster_timeout" {
  description = "The timeout to wait for the EKS cluster to be ready"
  type        = string
  default     = "5m"

}

### EKS Managed Node Group Variables ####
variable "use_name_prefix" {
  description = "Determines whether to use `name` as is or create a unique name beginning with the `name` as the prefix"
  type        = bool
  default     = true
}

variable "launch_template_use_name_prefix" {
  description = "Determines whether to use `launch_template_name` as is or create a unique name beginning with the `launch_template_name` as the prefix"
  type        = bool
  default     = true
}

variable "iam_role_use_name_prefix" {
  description = "Determines whether the IAM role name (`iam_role_name`) is used as a prefix"
  type        = bool
  default     = false
}

variable "volume_size" {
  description = "The size of the EBS volume"
  type        = number
  default     = 128
}

variable "device_name" {
  description = "The device name"
  type        = string
  default     = "/dev/xvda"
}

variable "volume_iops" {
  description = "The amount of provisioned IOPS"
  type        = number
  default     = 3000
}

variable "volume_throughput" {
  description = "The throughput of the EBS volume"
  type        = number
  default     = 125
}

variable "volume_encrypted" {
  description = "Indicates whether the EBS volume is encrypted"
  type        = bool
  default     = true
}

variable "volume_delete_on_termination" {
  description = "Indicates whether the EBS volume is deleted on termination"
  type        = bool
  default     = true
}

variable "update_config" {
  description = "Configuration block of settings for max unavailable resources during node group updates"
  type        = map(string)
  default = {
    max_unavailable = 1
  }
}
