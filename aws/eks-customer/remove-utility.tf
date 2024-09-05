resource null_resource "remove-utilities" {
  triggers = {
    gitops_repo_url = var.gitops_repo_url
    environment = var.environment
    cluster_name = module.eks.cluster_name
    node_groups = element(keys(module.managed_node_group), 0) #this is to ensure ordering, remove-utilities should run before managed_node_group destroy
  }
  provisioner "local-exec" {
    when = destroy
    command = <<EOT
      bash ${path.module}/scripts/remove-utility.sh
    EOT
    environment = {
      GIT_REPO_URL              = self.triggers.gitops_repo_url
      CLUSTER_NAME              = self.triggers.cluster_name
      ENV                       = self.triggers.environment
    }
  }
}
