locals {
  alarms_enabled = var.alarm_sns_topic_arn != ""
}

resource "aws_cloudwatch_metric_alarm" "engine_cpu" {
  count               = local.alarms_enabled ? 1 : 0
  alarm_name          = "${var.name}-engine-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "EngineCPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = 300
  statistic           = "Average"
  threshold           = var.alarm_engine_cpu_threshold
  alarm_description   = "Redis engine CPU on ${var.name} is above ${var.alarm_engine_cpu_threshold}% for 15 minutes"
  alarm_actions       = [var.alarm_sns_topic_arn]
  ok_actions          = [var.alarm_sns_topic_arn]
  treat_missing_data  = "ignore"
  dimensions          = { CacheClusterId = aws_elasticache_cluster.redis_cluster.cluster_id }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "memory" {
  count               = local.alarms_enabled ? 1 : 0
  alarm_name          = "${var.name}-memory"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "DatabaseMemoryUsagePercentage"
  namespace           = "AWS/ElastiCache"
  period              = 300
  statistic           = "Average"
  threshold           = var.alarm_memory_threshold
  alarm_description   = "Redis memory usage on ${var.name} is above ${var.alarm_memory_threshold}% for 15 minutes"
  alarm_actions       = [var.alarm_sns_topic_arn]
  ok_actions          = [var.alarm_sns_topic_arn]
  treat_missing_data  = "ignore"
  dimensions          = { CacheClusterId = aws_elasticache_cluster.redis_cluster.cluster_id }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "connections" {
  count               = local.alarms_enabled ? 1 : 0
  alarm_name          = "${var.name}-connections"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "CurrConnections"
  namespace           = "AWS/ElastiCache"
  period              = 300
  statistic           = "Maximum"
  threshold           = var.alarm_connections_threshold
  alarm_description   = "Peak Redis connections on ${var.name} are at or above ${var.alarm_connections_threshold} in 3 consecutive 5-minute periods"
  alarm_actions       = [var.alarm_sns_topic_arn]
  ok_actions          = [var.alarm_sns_topic_arn]
  treat_missing_data  = "ignore"
  dimensions          = { CacheClusterId = aws_elasticache_cluster.redis_cluster.cluster_id }

  tags = var.tags
}
