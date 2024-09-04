resource null_resource "remove-utilities" {
  triggers = {
    utilities = jsonencode(var.utilities)
    gitops_repo_url = var.gitops_repo_url
    environment = var.environment
    cluster_name = module.eks.cluster_name
  }
  provisioner "local-exec" {
    when = destroy
    command = <<EOT
      bash ${path.module}/scripts/remove-utility.sh '${self.triggers.utilities}'
    EOT
    environment = {
      GIT_REPO_URL              = self.triggers.gitops_repo_url
      CLUSTER_NAME              = self.triggers.cluster_name
      ENV                       = self.triggers.environment
    }
  }
}
