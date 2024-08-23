module "utilities" {
  source = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/argocd-utility?ref=cld-7696"

  utilities = var.utilities
  cluster_name = module.eks.cluster_name
  gitops_repo_url = var.gitops_repo_url
  environment = var.environment
  lb_certificate_arn = var.lb_certificate_arn
  lb_private_certificate_arn = var.lb_private_certificate_arn
  vpc_id = var.vpc_id
  private_domain = var.private_domain
  allow_list_cidr_range = var.allow_list_cidr_range
  api_server = module.eks.cluster_endpoint
  ca_data = module.eks.cluster_certificate_authority_data
  argocd_role_arn = var.argocd_role_arn
  oidc_provider_arn = module.eks.oidc_provider_arn

  depends_on = [ module.managed_node_group ]
}
