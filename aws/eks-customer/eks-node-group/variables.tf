variable "cluster_name" {
  description = "The name of the EKS cluster"
  type = string
}

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster"
  type = string
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

variable "cluster_service_cidr" {
  description = "The CIDR block for the cluster service"
  type = string
}

variable "cluster_primary_security_group_id" {
  description = "The security group ID for the EKS cluster"
  type = string
}

variable "node_security_group_id" {
  description = "The security group ID for the EKS nodes"
  type = string
}

variable "subnet_ids" {
  description = "The list of subnet IDs"
  type = list(string)
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