module "elb-cleanup" {
  source                      = "github.com/mattermost/mattermost-terraform-modules.git//aws/elb-cleanup?ref=v1.0.0"
  private_subnet_ids          = var.private_subnet_ids
  vpc_id                      = var.vpc_id
  deployment_name             = var.deployment_name
  bucket                      = var.bucket
  elb_cleanup_lambda_schedule = "rate(7 days)"
  dryrun                      = "true"
}
