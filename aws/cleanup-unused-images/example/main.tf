module "deckhand" {
  source             = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/cleanup-unused-images?ref=v1.6.0"
  private_subnet_ids = var.private_subnet_ids
  vpc_id             = var.vpc_id
  deployment_name    = var.deployment_name
  region             = var.region
  bucket             = var.bucket
}
