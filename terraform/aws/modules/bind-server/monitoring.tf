resource "aws_cloudwatch_metric_alarm" "low_free_storage_space" {
  for_each            = toset(var.hosts_list)
  alarm_name          = "${var.environment}-BindServerFreeStorageSpaceTooLow-${each.key}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = "86400"
  statistic           = "Average"
  threshold           = 90.0
  alarm_description   = "Average disk space usage is over 90% last 1 day"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"

  dimensions = {
    path   = "/"
    fstype = "ext4"
    host   = each.key
    device = "nvme0n1p1"
  }

}

resource "aws_cloudwatch_metric_alarm" "low_free_memory" {

  for_each            = toset(var.hosts_list)
  alarm_name          = "${var.environment}-BindServerFreeMemoryTooLow-${each.key}"
  comparison_operator = "LeesThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "mem_available_percent"
  namespace           = "CWAgent"
  period              = "3600"
  statistic           = "Average"
  threshold           = 10.0
  alarm_description   = "Average memory available is less than 10% last 1 hour"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"

  dimensions = {
    host = each.key
  }
}