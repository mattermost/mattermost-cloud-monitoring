locals {
  internal_domain = "internal.${var.environment}.${var.private_domain}"
}

resource null_resource "deploy-utilites" {
  provisioner "local-exec" {
    command = <<EOT
      bash ${path.module}/scripts/deploy-utility.sh '${jsonencode(var.utilities)}'
    EOT
    environment = {
      GIT_REPO_URL              = var.gitops_repo_url
      CLUSTER_NAME                = var.cluster_name
      ENV                       = var.environment
      CERTIFICATE_ARN           = var.lb_certificate_arn
      PRIVATE_CERTIFICATE_ARN   = var.lb_private_certificate_arn
      VPC_ID                    = var.vpc_id
      PRIVATE_DOMAIN            = local.internal_domain
      ALLOW_LIST_CIDR_RANGE     = var.allow_list_cidr_range
      API_SERVER                = var.api_server
      CA_DATA                   = var.ca_data
      ARGOCD_ROLE_ARN           = var.argocd_role_arn
    }
  }

  triggers = {
    always_run = timestamp()
  }
}
