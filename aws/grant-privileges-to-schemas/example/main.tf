module "account_alerts" {
  source                         = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/ebs-janitor?ref=v1.6.0"
  private_subnet_ids             = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
  min_subnet_free_ips            = "100"
  deployment_name                = "test"
  account_alerts_lambda_schedule = "rate(1 hour)"
  mattermost_alerts_hook         = "http://{your-mattermost-site}/hooks/xxx-generatedkey-xxx"
  vpc_id                         = "vpc-12345678"
}
