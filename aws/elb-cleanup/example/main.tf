module "elb-cleanup" {
  source                      = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/elb-cleanup?ref=1.6.0"
  private_subnet_ids          = var.private_subnet_ids
  vpc_id                      = var.vpc_id
  deployment_name             = var.deployment_name
  bucket                      = var.bucket
  elb_cleanup_lambda_schedule = "rate(7 days)"
  dryrun                      = "true"
}
