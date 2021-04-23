resource "aws_budgets_budget" "cloud_budget" {
  name              = "Cloud-${var.environment}-Budget"
  budget_type       = "COST"
  limit_amount      = var.amount
  limit_unit        = var.currency
  time_period_start = "2021-01-01_00:00"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = var.threshold
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.emails
    subscriber_sns_topic_arns  = var.sns_topic_arns
  }
}
