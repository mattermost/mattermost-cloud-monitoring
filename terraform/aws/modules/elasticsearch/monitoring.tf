resource "aws_cloudwatch_metric_alarm" "cluster_status_is_red" {
  count               = var.monitor_cluster_status_is_red ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}ElasticSearch-ClusterStatusIsRed${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ClusterStatus.red"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "Average elasticsearch cluster status is in red over last 1 minutes"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "cluster_status_is_yellow" {
  count               = var.monitor_cluster_status_is_yellow ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}ElasticSearch-ClusterStatusIsYellow${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "ClusterStatus.yellow"
  namespace           = "AWS/ES"
  period              = "120"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "Average elasticsearch cluster status is in yellow over last 4 minutes"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space_too_low" {
  count               = var.monitor_free_storage_space_too_low ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}ElasticSearch-FreeStorageSpaceTooLow${var.alarm_name_postfix}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Minimum"
  threshold           = local.thresholds["FreeStorageSpaceThreshold"]
  alarm_description   = "Average elasticsearch free storage space over last 1 minutes is too low"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "cluster_index_writes_blocked" {
  count               = var.monitor_cluster_index_writes_blocked ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}ElasticSearch-ClusterIndexWritesBlocked${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ClusterIndexWritesBlocked"
  namespace           = "AWS/ES"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "Elasticsearch index writes being blocker over last 5 minutes"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "insufficient_available_nodes" {
  count               = var.monitor_insufficient_available_nodes ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}ElasticSearch-InsufficientAvailableNodes${var.alarm_name_postfix}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Nodes"
  namespace           = "AWS/ES"
  period              = "86400"
  statistic           = "Minimum"
  threshold           = local.thresholds["MinimumAvailableNodes"]
  alarm_description   = "Elasticsearch nodes minimum < ${local.thresholds["MinimumAvailableNodes"]} for 1 day"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_too_high" {
  count               = var.monitor_cpu_utilization_too_high ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}ElasticSearch-CPUUtilizationTooHigh${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ES"
  period              = "900"
  statistic           = "Average"
  threshold           = local.thresholds["CPUUtilizationThreshold"]
  alarm_description   = "Average elasticsearch cluster CPU utilization over last 45 minutes too high"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "jvm_memory_pressure_too_high" {
  count               = var.monitor_jvm_memory_pressure_too_high ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}ElasticSearch-JVMMemoryPressure${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "JVMMemoryPressure"
  namespace           = "AWS/ES"
  period              = "900"
  statistic           = "Maximum"
  threshold           = local.thresholds["JVMMemoryPressureThreshold"]
  alarm_description   = "Elasticsearch JVM memory pressure is too high over last 15 minutes"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_cpu_utilization_too_high" {
  count               = var.monitor_master_cpu_utilization_too_high ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}ElasticSearch-MasterCPUUtilizationTooHigh${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "MasterCPUUtilization"
  namespace           = "AWS/ES"
  period              = "900"
  statistic           = "Average"
  threshold           = local.thresholds["MasterCPUUtilizationThreshold"]
  alarm_description   = "Average elasticsearch cluster CPU utilization over last 45 minutes too high"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

resource "aws_cloudwatch_metric_alarm" "master_jvm_memory_pressure_too_high" {
  count               = var.monitor_master_jvm_memory_pressure_too_high ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}ElasticSearch-MasterJVMMemoryPressure${var.alarm_name_postfix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MasterJVMMemoryPressure"
  namespace           = "AWS/ES"
  period              = "900"
  statistic           = "Maximum"
  threshold           = local.thresholds["MasterJVMMemoryPressureThreshold"]
  alarm_description   = "Elasticsearch JVM memory pressure is too high over last 15 minutes"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.current.account_id
  }
}


resource "aws_cloudwatch_metric_alarm" "master_not_reachable_from_node" {
  count               = var.monitor_master_not_reachable_from_node ? 1 : 0
  alarm_name          = "${var.alarm_name_prefix}ElasticSearch-MasterNotReachableFromNode${var.alarm_name_postfix}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MasterReachableFromNode"
  namespace           = "AWS/ES"
  period              = "600"
  statistic           = "Minimum"
  threshold           = 0
  alarm_description   = "Elasticsearch master not reachable for 10 minutes"
  alarm_actions       = [local.aws_sns_topic_arn]
  ok_actions          = [local.aws_sns_topic_arn]
  treat_missing_data  = "ignore"

  dimensions = {
    DomainName = var.domain_name
    ClientId   = data.aws_caller_identity.current.account_id
  }
}