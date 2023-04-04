module "cluster-post-installation" {
  source      = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/cluster-post-installation?ref=1.6.0"
  environment = var.environment
}
