## Cloudwatch alarms for RDS to comply with SOC2 instructions
locals {
  alarm_instance_identifier = var.cluster_instance_identifier == "" ? var.db_instance_identifier : var.cluster_instance_identifier
}

data "aws_sns_topic" "aurora_cluster_topic" {
  name = var.sns_topic
}

resource "aws_cloudwatch_metric_alarm" "db_instances_alarm_cpu" {
  alarm_name          = format("%s-cpu", local.alarm_instance_identifier)
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "90"
  alarm_description   = "This metric monitors RDS DB Instance cpu utilization"
  actions_enabled     = true
  alarm_actions       = [data.aws_sns_topic.aurora_cluster_topic.arn]
  dimensions          = { DBInstanceIdentifier = var.db_instance_identifier }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "db_instances_alarm_memory" {
  alarm_name          = format("%s-memory", local.alarm_instance_identifier)
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "3"
  threshold           = var.memory_alarm_limit
  alarm_description   = "This metric monitors RDS DB Instance freeable memory"

  metric_query {
    id          = "e1"
    expression  = "m1+${var.memory_cache_proportion}*${var.ram_memory_bytes[var.instance_type]}"
    label       = "Total Free Memory"
    return_data = "true"
  }

  metric_query {
    id = "m1"
    metric {
      metric_name = "FreeableMemory"
      namespace   = "AWS/RDS"
      period      = "600"
      stat        = "Average"
      dimensions  = { DBInstanceIdentifier = var.db_instance_identifier }
    }
    return_data = "false"
  }
  actions_enabled = true
  alarm_actions   = [data.aws_sns_topic.aurora_cluster_topic.arn]

  lifecycle {
    ignore_changes = [
      metric_query
    ]
  }

  tags = var.tags
}
