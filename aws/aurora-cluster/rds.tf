locals {
  cluster_identifier                 = var.cluster_identifier
  cluster_instance_identifier        = var.cluster_instance_identifier == "" ? var.cluster_identifier : var.cluster_instance_identifier
  cluster_instance_identifier_reader = var.cluster_instance_identifier == "" ? var.cluster_identifier : "${var.cluster_instance_identifier}-reader"
  master_password                    = var.password == "" ? random_password.master_password.result : var.password
  performance_insights_enabled       = var.environment == "prod" ? var.performance_insights_enabled : false
}

# Random string to use as master password unless one is specified
resource "random_password" "master_password" {
  length  = 16
  special = false
}

data "aws_iam_role" "enhanced_monitoring" {
  name = "rds-enhanced-monitoring-mattermost-cloud-${var.environment}-provisioning"
}

resource "aws_rds_cluster" "provisioning_rds_cluster" {
  cluster_identifier              = local.cluster_identifier
  engine                          = var.engine
  engine_version                  = var.engine_version
  engine_mode                     = var.engine_mode
  kms_key_id                      = var.kms_key
  master_username                 = var.username
  master_password                 = local.master_password
  final_snapshot_identifier       = "${var.final_snapshot_identifier_prefix}-${format("%s", local.cluster_identifier)}"
  skip_final_snapshot             = var.skip_final_snapshot
  deletion_protection             = var.deletion_protection
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  port                            = var.port
  db_subnet_group_name            = var.db_subnet_group_name
  vpc_security_group_ids          = var.vpc_security_group_ids
  storage_encrypted               = var.storage_encrypted
  apply_immediately               = var.apply_immediately
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.cluster_parameter_group_postgresql.id
  copy_tags_to_snapshot           = var.copy_tags_to_snapshot
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  snapshot_identifier             = var.creation_snapshot_arn == "" ? null : var.creation_snapshot_arn

  serverlessv2_scaling_configuration {
    max_capacity = var.max_capacity
    min_capacity = var.min_capacity
  }

  tags = merge(
    {
      "VpcID"        = var.vpc_id,
      "DatabaseType" = var.service_name,
      "Name"         = var.service_name,
    },
    var.tags
  )
}

resource "aws_rds_cluster_instance" "provisioning_rds_db_instance" {
  count                                 = var.replica_min
  identifier                            = local.cluster_instance_identifier
  cluster_identifier                    = aws_rds_cluster.provisioning_rds_cluster.id
  engine                                = var.engine
  engine_version                        = var.engine_version
  instance_class                        = var.instance_type
  db_subnet_group_name                  = var.db_subnet_group_name
  db_parameter_group_name               = aws_db_parameter_group.db_parameter_group_postgresql.id
  preferred_maintenance_window          = var.preferred_maintenance_window
  apply_immediately                     = var.apply_immediately
  monitoring_role_arn                   = data.aws_iam_role.enhanced_monitoring.arn
  monitoring_interval                   = var.monitoring_interval
  promotion_tier                        = count.index + 1
  performance_insights_enabled          = local.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  publicly_accessible                   = var.publicly_accessible


  tags = merge(
    {
      "Name"         = var.service_name,
      "DatabaseType" = var.service_name,
      "Environment"  = var.environment
    },
    var.tags
  )
}

resource "aws_rds_cluster_instance" "provisioning_rds_db_instance_reader" {
  count                                 = var.replica_min
  identifier                            = local.cluster_instance_identifier_reader
  cluster_identifier                    = aws_rds_cluster.provisioning_rds_cluster.id
  engine                                = var.engine
  engine_version                        = var.engine_version
  instance_class                        = var.instance_type
  db_subnet_group_name                  = var.db_subnet_group_name
  db_parameter_group_name               = aws_db_parameter_group.db_parameter_group_postgresql.id
  preferred_maintenance_window          = var.preferred_maintenance_window
  apply_immediately                     = var.apply_immediately
  monitoring_role_arn                   = data.aws_iam_role.enhanced_monitoring.arn
  monitoring_interval                   = var.monitoring_interval
  promotion_tier                        = count.index + 1
  performance_insights_enabled          = local.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  publicly_accessible                   = var.publicly_accessible


  tags = merge(
    {
      "Name"         = var.service_name,
      "DatabaseType" = var.service_name,
      "Environment"  = var.environment
    },
    var.tags
  )
}

resource "random_string" "db_cluster_identifier" {
  length = 8
}


resource "aws_secretsmanager_secret" "master_password" {
  name = format("%s-%s", var.service_name, var.environment)
}

resource "aws_secretsmanager_secret_version" "master_password" {
  secret_id     = aws_secretsmanager_secret.master_password.id
  secret_string = local.master_password
}

#resource "aws_cloudwatch_metric_alarm" "db_instances_alarm_cpu" {
#  count               = !var.engine_mode_serverlessV2 ? var.replica_min : 0
#  alarm_name          = format("%s-cpu", local.cluster_identifier)
#  comparison_operator = "GreaterThanOrEqualToThreshold"
#  evaluation_periods  = "3"
#  metric_name         = "CPUUtilization"
#  namespace           = "AWS/RDS"
#  period              = "600"
#  statistic           = "Average"
#  threshold           = "80"
#  alarm_description   = "This metric monitors RDS DB Instance cpu utilization"
#  actions_enabled     = true
#  alarm_actions       = [var.sns_topic_arn]
#  dimensions          = { DBInstanceIdentifier = aws_rds_cluster_instance.provisioning_rds_db_instance[count.index].identifier }
#}

#resource "aws_cloudwatch_metric_alarm" "db_instances_alarm_memory" {
#  count               = !var.engine_mode_serverlessV2 ? var.replica_min : 0
#  alarm_name          = format("%s-memory", local.cluster_identifier)
#  comparison_operator = "LessThanOrEqualToThreshold"
#  evaluation_periods  = "3"
#  threshold           = var.memory_alarm_limit
#  alarm_description   = "This metric monitors RDS DB Instance freeable memory"
#  metric_query {
#    id          = "e1"
#    expression  = "m1+${var.memory_cache_proportion}*${var.ram_memory_bytes[var.instance_type]}"
#    label       = "Total Free Memory"
#    return_data = "true"
#  }
#
#  metric_query {
#    id = "m1"
#    metric {
#      metric_name = "FreeableMemory"
#      namespace   = "AWS/RDS"
#      period      = "600"
#      stat        = "Average"
#      dimensions  = { DBInstanceIdentifier = aws_rds_cluster_instance.provisioning_rds_db_instance[count.index].identifier }
#    }
#    return_data = "false"
#  }
#  actions_enabled = true
#  alarm_actions   = [var.sns_topic_arn]
#
#  lifecycle {
#    ignore_changes = [
#      metric_query
#    ]
#  }
#}


resource "aws_db_parameter_group" "db_parameter_group_postgresql" {

  name   = format("%s-pg", local.cluster_identifier)
  family = var.aurora_family

  tags = merge(
    {
      "Name"         = var.service_name,
      "DatabaseType" = var.service_name,
      "Environment"  = var.environment
    },
    var.tags
  )
}

resource "aws_rds_cluster_parameter_group" "cluster_parameter_group_postgresql" {

  name   = format("%s-pg", local.cluster_identifier)
  family = var.aurora_family


  tags = merge(
    {
      "Name"         = var.service_name,
      "DatabaseType" = var.service_name,
      "Environment"  = var.environment
    },
    var.tags
  )
}

resource "aws_cloudwatch_log_group" "rds-cluster-log-group" {
  name       = format("%s/postgresql", local.cluster_identifier)
  depends_on = [aws_rds_cluster.provisioning_rds_cluster]
}
