
module "billing" {
  source         = "github.com/mattermost/mattermost-terraform-modules.git//aws/billing?ref=v1.0.0"
  environment    = "dev"
  amount         = "1500"
  currency       = "USD"
  emails         = "foo@bar.com"
  threshold      = "90"
  sns_topic_arns = "arn:aws:sns:us-east-1:123456789012:dev"
}

