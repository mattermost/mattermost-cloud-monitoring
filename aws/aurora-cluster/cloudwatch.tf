data "aws_sns_topic" "aurora_cluster_topic" {
  name = "aurora-cluster-${var.environment}"
}

resource "aws_cloudwatch_metric_alarm" "db_instances_alarm_cpu" {
  count               = var.enable_rds_alerting ? var.replica_min : 0
  alarm_name          = format("%s-cpu", local.cluster_instance_identifier)
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
  dimensions          = { DBInstanceIdentifier = aws_rds_cluster_instance.provisioning_rds_db_instance[count.index].identifier }
}

resource "aws_cloudwatch_metric_alarm" "db_instances_alarm_memory" {
  count               = var.enable_rds_alerting ? var.replica_min : 0
  alarm_name          = format("%s-memory", local.cluster_instance_identifier)
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
      dimensions  = { DBInstanceIdentifier = aws_rds_cluster_instance.provisioning_rds_db_instance[count.index].identifier }
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
}
