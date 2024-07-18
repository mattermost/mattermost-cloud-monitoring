resource null_resource "clone-gitops-repo" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/clone-gitops-repo.sh"
    environment = {
      GIT_REPO_URL = var.git_repo_url
    }
  }
}

resource null_resource "deploy-utilites" {
  for_each = var.utilities
  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/deploy-utility.sh ${each.value.name}"
    environment = {
      GIT_REPO_URL   = var.git_repo_url
      CLUSTER_ID     = var.cluster_id
      ENV            = var.environment
      CERTIFICATE_ARN = var.certificate_arn
      PRIVATE_CERTIFICATE_ARN = var.private_certificate_arn
      VPC_ID         = var.vpc_id
      PRIVATE_DOMAIN = var.private_domain
      IP_RANGE = var.ip_range
    }
  }

  triggers = {
    always_run = timestamp()
  }

  depends_on = [ null_resource.clone-gitops-repo ]
}

# resource null_resource "push-argocd-apps" {
#   triggers = {
#     always_run = timestamp()
#   }
#   provisioner "local-exec" {
#     command = "bash ${path.module}/scripts/push-argocd-apps.sh"
#     environment = {
#       CLUSTER_ID = var.cluster_id
#       GIT_REPO_URL = var.git_repo_url
#     }
#   }
# }