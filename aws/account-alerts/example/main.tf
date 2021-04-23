module "account_alerts" {
  source                         = "github.com/mattermost/mattermost-terraform-modules.git//aws/account-alerts?ref=v1.0.0"
  private_subnet_ids             = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
  min_subnet_free_ips            = "100"
  deployment_name                = "test"
  account_alerts_lambda_schedule = "rate(1 hour)"
  mattermost_alerts_hook         = "http://{your-mattermost-site}/hooks/xxx-generatedkey-xxx"
  vpc_id                         = "vpc-12345678"
}
