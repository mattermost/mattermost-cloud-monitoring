resource "null_resource" "remove-utilities" {
  count = var.node_groups != {} ? 1 : 0
  triggers = {
    gitops_repo_path           = var.gitops_repo_path
    gitops_repo_url            = var.gitops_repo_url
    gitops_repo_username       = var.gitops_repo_username
    gitops_repo_email          = var.gitops_repo_email
    github_token               = nonsensitive(data.github_app_token.this.token)
    github_app_installation_id = var.github_app_installation_id
    environment                = var.environment
    cluster_name               = module.eks.cluster_name
  }
  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      bash ${path.module}/scripts/remove-utility.sh
    EOT
    environment = {
      GIT_REPO_PATH              = self.triggers.gitops_repo_path
      GIT_REPO_URL               = self.triggers.gitops_repo_url
      GIT_REPO_USERNAME          = self.triggers.gitops_repo_username
      GIT_REPO_EMAIL             = self.triggers.gitops_repo_email
      GITHUB_TOKEN               = self.triggers.github_token
      GITHUB_APP_INSTALLATION_ID = self.triggers.github_app_installation_id
      CLUSTER_NAME               = self.triggers.cluster_name
      ENV                        = self.triggers.environment
    }
  }
}

resource "null_resource" "wait_before_destroy_node_group" {
  count = var.node_groups != {} ? 1 : 0
  triggers = {
    node_groups = join("\n", keys(module.managed_node_group)) #this is to ensure ordering, wait_before_destroy_node_group should run before managed_node_group destroy
  }
  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      echo "Starting to destroy node group"
    EOT
  }

  depends_on = [null_resource.remove-utilities]
}
