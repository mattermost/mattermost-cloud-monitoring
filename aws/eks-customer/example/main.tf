module "eks" {
  for_each = { for s in var.clusters : s.cluster_name => s }

  source = "git::https://github.com/mattermost/mattermost-cloud-monitoring.git//aws/eks-customer?ref=cld-7696"

  cluster_name                            = each.value.cluster_name
  cluster_version                         = each.value.cluster_version
  vpc_id                                  = each.value.vpc_id
  environment                             = var.environment
  utilities                               = var.utilities
  cluster_endpoint_public_access          = var.cluster_endpoint_public_access
  cluster_endpoint_private_access         = var.cluster_endpoint_private_access
  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules
  cluster_enabled_log_types               = var.cluster_enabled_log_types
  calico_operator_version                 = var.calico_operator_version
  node_groups                             = each.value.node_groups
  cloud_provisioning_node_policy_arn      = var.cloud_provisioning_node_policy_arn
  coredns_version                         = var.coredns_version
  kube_proxy_version                      = var.kube_proxy_version
  ebs_csi_driver_version                  = var.ebs_csi_driver_version
  snapshot_controller_version             = var.snapshot_controller_version
  lb_certificate_arn                      = var.lb_certificate_arn
  lb_private_certificate_arn              = var.lb_private_certificate_arn
  argocd_role_arn                         = var.argocd_role_arn
  argocd_server                           = var.argocd_server
  staff_role_arn                          = var.staff_role_arn
  provisioner_role_arn                    = var.provisioner_role_arn
  allow_list_cidr_range                   = var.allow_list_cidr_range
  gitops_repo_path                        = var.gitops_repo_path
  gitops_repo_url                         = var.gitops_repo_url
  gitops_repo_username                    = var.gitops_repo_username
  private_domain                          = "cloud.mattermost.com"
  cluster_tags = {
    "Name" = each.value.cluster_name
  }
}
