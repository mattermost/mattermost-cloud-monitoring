module "utilities" {
  source = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/argocd-utility?ref=cld-7696"

  utilities = var.utilities
  cluster_id = module.eks.cluster_name
  git_repo_url = var.git_repo_url
  environment = var.environment
  lb_certificate_arn = var.lb_certificate_arn
  lb_private_certificate_arn = var.lb_private_certificate_arn
  vpc_id = var.vpc_id
  private_domain = var.private_domain
  ip_range = var.ip_range
  api_server = module.eks.cluster_endpoint
  ca_data = module.eks.cluster_certificate_authority_data
  cluster_name = var.cluster_name
  argocd_role_arn = var.argocd_role_arn

  depends_on = [ module.eks, module.managed_node_group ]
}