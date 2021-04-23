module "cluster-post-installation" {
  source      = "github.com/mattermost/mattermost-terraform-modules.git//aws/cluster-post-installation?ref=v1.0.0"
  environment = var.environment
}
