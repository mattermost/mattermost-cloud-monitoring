resource "null_resource" "remove-utilities" {
  count = var.node_groups != {} ? 1 : 0
  triggers = {
    gitops_repo_path     = var.gitops_repo_path
    gitops_repo_url      = var.gitops_repo_url
    gitops_repo_username = var.gitops_repo_username
    environment          = var.environment
    cluster_name         = module.eks.cluster_name
    node_groups          = element(keys(module.managed_node_group), 0) #this is to ensure ordering, remove-utilities should run before managed_node_group destroy
  }
  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      bash ${path.module}/scripts/remove-utility.sh
    EOT
    environment = {
      GIT_REPO_PATH     = self.triggers.gitops_repo_path
      GIT_REPO_URL      = self.triggers.gitops_repo_url
      GIT_REPO_USERNAME = self.triggers.gitops_repo_username
      CLUSTER_NAME      = self.triggers.cluster_name
      ENV               = self.triggers.environment
    }
  }
}
