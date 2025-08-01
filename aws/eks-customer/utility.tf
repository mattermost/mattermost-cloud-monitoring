resource "null_resource" "deploy-utilites" {
  provisioner "local-exec" {
    command = <<EOT
      bash ${path.module}/scripts/deploy-utility.sh '${jsonencode(var.utilities)}'
    EOT
    environment = {
      GIT_REPO_PATH              = var.gitops_repo_path
      GIT_REPO_URL               = var.gitops_repo_url
      GIT_REPO_USERNAME          = var.gitops_repo_username
      GIT_REPO_EMAIL             = var.gitops_repo_email
      GITHUB_APP_INSTALLATION_ID = var.github_app_installation_id
      GITHUB_APP_ID              = var.github_app_id
      GITHUB_APP_PEM_FILE        = var.github_app_pem_key_path
      CLUSTER_NAME               = module.eks.cluster_name
      ENV                        = var.environment
      CERTIFICATE_ARN            = var.lb_certificate_arn
      PRIVATE_CERTIFICATE_ARN    = var.lb_private_certificate_arn
      VPC_ID                     = var.vpc_id
      PRIVATE_DOMAIN             = local.internal_domain
      ALLOW_LIST_CIDR_RANGE      = var.allow_list_cidr_range
      API_SERVER                 = module.eks.cluster_endpoint
      CA_DATA                    = module.eks.cluster_certificate_authority_data
      ARGOCD_ROLE_ARN            = var.argocd_role_arn
      ARGOCD_SERVER              = var.argocd_server
      AWS_ACCOUNT                = data.aws_caller_identity.current.account_id
      PUSH_UTILITIES_TO_MAIN     = var.push_utilities_to_main
      BRANCH_NAME                = "${module.eks.cluster_name}-deploy-utilities-${formatdate("YYMMDDhhss", timestamp())}--delete-after-merge"
    }
  }

  triggers = {
    always_run = timestamp()
  }

  depends_on = [module.eks, module.managed_node_group.node_group_status]
}

