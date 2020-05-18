
data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_metric_alarm" "grafana_metrics" {
  for_each = toset(var.metrics)

  alarm_name                = "${each.value}-quota-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = each.value
  namespace                 = "AWS/Grafana"
  period                    = "3600"
  statistic                 = "Average"
  threshold                 = var.alarm_threshold
  alarm_description         = "This metric monitors ${each.value} utilization"
  actions_enabled           = "true"
  alarm_actions             = ["arn:aws:sns:us-east-1:${data.aws_caller_identity.current.account_id}:elb-alarm-topic"]
  ok_actions                = ["arn:aws:sns:us-east-1:${data.aws_caller_identity.current.account_id}:elb-alarm-topic"]
}
