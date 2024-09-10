# module "utilities" {
#   # source = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/argocd-utility?ref=cld-7696"
#   source = "/Users/andreleite/code/src/github/mattermost/mattermost-cloud-monitoring/aws/argocd-utility"

#   utilities = var.utilities
#   cluster_name = var.cluster_name
#   gitops_repo_url = var.gitops_repo_url
#   environment = var.environment
#   lb_certificate_arn = var.lb_certificate_arn
#   lb_private_certificate_arn = var.lb_private_certificate_arn
#   vpc_id = var.vpc_id
#   private_domain = var.private_domain
#   allow_list_cidr_range = var.allow_list_cidr_range
#   api_server = module.eks.cluster_endpoint
#   ca_data = module.eks.cluster_certificate_authority_data
#   argocd_role_arn = var.argocd_role_arn
#   oidc_provider_arn = module.eks.oidc_provider_arn
#   internal_lb_endpoint = "test-endpoint"

#   #depends_on = [ module.managed_node_group ]
# }

locals {
  internal_domain = "internal.${var.environment}.${var.private_domain}"
}

resource "null_resource" "deploy-utilites" {
  provisioner "local-exec" {
    command = <<EOT
      bash ${path.module}/scripts/deploy-utility.sh '${jsonencode(var.utilities)}'
    EOT
    environment = {
      GIT_REPO_URL            = var.gitops_repo_url
      CLUSTER_NAME            = module.eks.cluster_name
      ENV                     = var.environment
      CERTIFICATE_ARN         = var.lb_certificate_arn
      PRIVATE_CERTIFICATE_ARN = var.lb_private_certificate_arn
      VPC_ID                  = var.vpc_id
      PRIVATE_DOMAIN          = local.internal_domain
      ALLOW_LIST_CIDR_RANGE   = var.allow_list_cidr_range
      API_SERVER              = module.eks.cluster_endpoint
      CA_DATA                 = module.eks.cluster_certificate_authority_data
      ARGOCD_ROLE_ARN         = var.argocd_role_arn
    }
  }

  triggers = {
    always_run = timestamp()
  }

  depends_on = [module.eks, time_sleep.wait_for_cluster, module.managed_node_group.node_group_status]
}
