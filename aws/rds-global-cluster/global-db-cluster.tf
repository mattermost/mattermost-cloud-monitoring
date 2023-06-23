resource "aws_rds_global_cluster" "global-cluster" {
  global_cluster_identifier = var.global_cluster_identifier
  engine                    = var.engine
  engine_version            = var.engine_version
  database_name             = var.database_name
  storage_encrypted         = var.storage_encrypted
}

data "aws_iam_role" "enhanced_monitoring" {
  name = substr("rds-enhanced-monitoring-mattermost-cloud-${var.environment}-provisioning", 0, 64)
}

resource "aws_rds_cluster" "primary" {
  provider                        = aws.primary
  engine                          = aws_rds_global_cluster.global-cluster.engine
  engine_version                  = aws_rds_global_cluster.global-cluster.engine_version
  cluster_identifier              = var.primary_cluster_identifier
  master_username                 = var.master_username
  master_password                 = var.master_password
  database_name                   = var.database_name
  global_cluster_identifier       = aws_rds_global_cluster.global-cluster.id
  kms_key_id                      = var.primary_kms_key
  storage_encrypted               = var.storage_encrypted
  apply_immediately               = var.apply_immediately
  db_subnet_group_name            = var.primary_db_subnet_group_name
  vpc_security_group_ids          = var.primary_vpc_security_group_ids
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.cluster_parameter_group_postgresql.id
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  skip_final_snapshot             = var.skip_final_snapshot
  final_snapshot_identifier       = local.final_snapshot_identifier
  enabled_cloudwatch_logs_exports = var.primary_enabled_cloudwatch_logs_exports
  tags = merge(
    {
      "VpcID"                 = var.primary_vpc_id,
      "MultitenantDatabaseID" = var.primary_cluster_identifier
    },
    var.tags
  )
}

resource "aws_rds_cluster_instance" "primary" {
  count                                 = var.primary_instances_count
  provider                              = aws.primary
  engine                                = aws_rds_global_cluster.global-cluster.engine
  engine_version                        = aws_rds_global_cluster.global-cluster.engine_version
  identifier                            = "${var.primary_cluster_identifier}-${count.index}"
  cluster_identifier                    = aws_rds_cluster.primary.id
  instance_class                        = var.instance_class
  db_subnet_group_name                  = var.primary_db_subnet_group_name
  db_parameter_group_name               = aws_db_parameter_group.db_parameter_group_postgresql.id
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  monitoring_role_arn                   = data.aws_iam_role.enhanced_monitoring.arn
  monitoring_interval                   = var.monitoring_interval
  tags = merge(
    {
      "VpcID"                 = var.primary_vpc_id,
      "MultitenantDatabaseID" = "${var.primary_cluster_identifier}-${count.index}"
    },
    var.tags
  )

  depends_on = [
    aws_rds_cluster.primary
  ]
}

resource "aws_rds_cluster" "secondary" {
  provider                        = aws.secondary
  engine                          = aws_rds_global_cluster.global-cluster.engine
  engine_version                  = aws_rds_global_cluster.global-cluster.engine_version
  cluster_identifier              = var.secondary_cluster_identifier
  global_cluster_identifier       = aws_rds_global_cluster.global-cluster.id
  db_subnet_group_name            = var.secondary_db_subnet_group_name
  vpc_security_group_ids          = var.secondary_vpc_security_group_ids
  kms_key_id                      = var.secondary_kms_key
  storage_encrypted               = var.storage_encrypted
  apply_immediately               = var.apply_immediately
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.cluster_parameter_group_postgresql.id
  enabled_cloudwatch_logs_exports = var.secondary_enabled_cloudwatch_logs_exports
  tags = merge(
    {
      "VpcID"                 = var.secondary_vpc_id,
      "MultitenantDatabaseID" = var.secondary_cluster_identifier
    },
    var.tags
  )
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = local.final_snapshot_identifier

  depends_on = [
    aws_rds_cluster.primary
  ]
}

resource "aws_rds_cluster_instance" "secondary" {
  count                                 = var.secondary_instances_count
  provider                              = aws.secondary
  engine                                = aws_rds_global_cluster.global-cluster.engine
  engine_version                        = aws_rds_global_cluster.global-cluster.engine_version
  identifier                            = "${var.secondary_cluster_identifier}-${count.index}"
  cluster_identifier                    = aws_rds_cluster.secondary.id
  instance_class                        = var.instance_class
  db_subnet_group_name                  = var.secondary_db_subnet_group_name
  db_parameter_group_name               = aws_db_parameter_group.db_parameter_group_postgresql.id
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  monitoring_role_arn                   = data.aws_iam_role.enhanced_monitoring.arn
  monitoring_interval                   = var.monitoring_interval
  tags = merge(
    {
      "VpcID"                 = var.secondary_vpc_id,
      "MultitenantDatabaseID" = "${var.secondary_cluster_identifier}-${count.index}"
    },
    var.tags
  )

  depends_on = [
    aws_rds_cluster.secondary
  ]
}

resource "aws_db_parameter_group" "db_parameter_group_postgresql" {

  name   = format("%s-pg", var.global_cluster_identifier)
  family = var.aurora_family

  parameter {
    name  = "log_min_duration_statement"
    value = var.log_min_duration_statement
  }

  tags = var.tags
}

resource "aws_rds_cluster_parameter_group" "cluster_parameter_group_postgresql" {

  name   = format("%s-pg", var.global_cluster_identifier)
  family = var.aurora_family

  parameter {
    name  = "log_min_duration_statement"
    value = var.log_min_duration_statement
  }

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "rds-cluster-log-group" {
  name       = format("%s/postgresql", var.global_cluster_identifier)
  depends_on = [aws_rds_cluster.primary, aws_rds_cluster.secondary]
}
