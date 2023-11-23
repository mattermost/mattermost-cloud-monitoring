locals {
  master_password               = var.password == "" ? random_password.master_password.result : var.password
  database_id                   = var.db_id == "" ? random_string.db_cluster_identifier.result : var.db_id
  max_connections               = var.ram_memory_bytes[var.instance_type] / 9531392
  performance_insights_enabled  = var.environment == "prod" ? var.performance_insights_enabled : false
  cluster_kms_key_arn_primary   = var.kms_key_id_primary == "" ? aws_kms_key.aurora_storage_key_primary[0].arn : var.kms_key_id_primary
  cluster_kms_key_arn_secondary = var.kms_key_id_secondary == "" && var.enable_global_cluster ? aws_kms_key.aurora_storage_key_secondary[0].arn : var.kms_key_id_secondary
}

# Random string to use as master password unless one is specified
resource "random_password" "master_password" {
  length  = 16
  special = false

  lifecycle {
    ignore_changes = [
      special,
    ]
  }
}

data "aws_iam_role" "enhanced_monitoring" {
  name = "rds-enhanced-monitoring-mattermost-cloud-${var.environment}-provisioning"
}

resource "aws_kms_key" "aurora_storage_key_primary" {
  count                   = var.kms_key_id_primary == "" ? 1 : 0
  description             = format("rds-multitenant-storage-key-%s-%s", split("-", var.primary_vpc_id)[1], local.database_id)
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_key" "aurora_storage_key_secondary" {
  count                   = var.kms_key_id_secondary == "" && var.enable_global_cluster ? 1 : 0
  provider                = aws.secondary
  description             = format("rds-multitenant-storage-key-%s-%s", split("-", var.secondary_vpc_id)[1], local.database_id)
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "aurora_storage_alias_primary" {
  count         = var.kms_key_id_primary == "" ? 1 : 0
  name          = "alias/${format("rds-multitenant-storage-key-%s-%s", split("-", var.primary_vpc_id)[1], local.database_id)}"
  target_key_id = local.cluster_kms_key_arn_primary
}

resource "aws_kms_alias" "aurora_storage_alias_secondary" {
  count         = var.kms_key_id_secondary == "" && var.enable_global_cluster ? 1 : 0
  provider      = aws.secondary
  name          = "alias/${format("rds-multitenant-storage-key-%s-%s", split("-", var.secondary_vpc_id)[1], local.database_id)}"
  target_key_id = local.cluster_kms_key_arn_secondary
}


data "aws_security_group" "db_sg_primary" {
  provider = aws.primary
  name     = format("mattermost-cloud-%s-provisioning-%s-db-postgresql-sg", var.environment, join("", split(".", split("/", data.aws_vpc.provisioning_vpc_primary.cidr_block)[0])))
}

data "aws_security_group" "db_sg_secondary" {
  count    = var.enable_global_cluster ? 1 : 0
  provider = aws.secondary
  name     = format("mattermost-cloud-%s-provisioning-%s-db-postgresql-sg", var.environment, join("", split(".", split("/", data.aws_vpc.provisioning_vpc_secondary[0].cidr_block)[0])))
}

data "aws_vpc" "provisioning_vpc_primary" {
  provider = aws.primary
  id       = var.primary_vpc_id
}

data "aws_vpc" "provisioning_vpc_secondary" {
  count    = var.enable_global_cluster ? 1 : 0
  provider = aws.secondary
  id       = var.secondary_vpc_id
}

resource "aws_rds_global_cluster" "global-cluster" {
  count                        = var.enable_global_cluster ? 1 : 0
  force_destroy                = true
  database_name                = postgres
  global_cluster_identifier    = format("rds-cluster-multitenant-%s-%s", split("-", var.primary_vpc_id)[1], local.database_id)
  source_db_cluster_identifier = aws_rds_cluster.provisioning_rds_cluster_primary.arn
}

resource "aws_rds_cluster" "provisioning_rds_cluster_primary" {
  provider                         = aws.primary
  cluster_identifier               = format("rds-cluster-multitenant-%s-%s", split("-", var.primary_vpc_id)[1], local.database_id)
  engine                           = var.engine
  engine_version                   = var.engine_version
  kms_key_id                       = local.cluster_kms_key_arn_primary
  master_username                  = var.username
  master_password                  = local.master_password
  final_snapshot_identifier        = "${var.final_snapshot_identifier_prefix}-${format("rds-cluster-multitenant-%s-%s", split("-", var.primary_vpc_id)[1], local.database_id)}"
  skip_final_snapshot              = var.skip_final_snapshot
  deletion_protection              = var.deletion_protection
  backup_retention_period          = var.backup_retention_period
  preferred_backup_window          = var.preferred_backup_window
  preferred_maintenance_window     = var.preferred_maintenance_window
  port                             = var.port
  db_subnet_group_name             = "mattermost-provisioner-db-${var.primary_vpc_id}-postgresql"
  vpc_security_group_ids           = [data.aws_security_group.db_sg_primary.id]
  storage_encrypted                = var.storage_encrypted
  apply_immediately                = var.apply_immediately
  db_cluster_parameter_group_name  = aws_rds_cluster_parameter_group.cluster_parameter_group_postgresql_primary.id
  db_instance_parameter_group_name = aws_db_parameter_group.db_parameter_group_postgresql_primary.id
  copy_tags_to_snapshot            = var.copy_tags_to_snapshot
  snapshot_identifier              = var.creation_snapshot_arn_primary == "" ? null : var.creation_snapshot_arn_primary
  allow_major_version_upgrade      = var.allow_major_version_upgrade
  enabled_cloudwatch_logs_exports  = var.enabled_cloudwatch_logs_exports


  tags = merge(
    {
      "Counter"                             = 0,
      "MultitenantDatabaseID"               = format("rds-cluster-multitenant-%s-%s", split("-", var.primary_vpc_id)[1], local.database_id),
      "VpcID"                               = var.primary_vpc_id,
      "DatabaseType"                        = var.multitenant_tag,
      "MattermostCloudInstallationDatabase" = "PostgreSQL/Aurora"
    },
    var.tags
  )
  lifecycle {
    ignore_changes = [
      tags["Counter"],
      global_cluster_identifier
    ]
  }
}

resource "aws_rds_cluster_instance" "provisioning_rds_db_instance_primary" {
  count                           = var.replica_min_primary
  provider                        = aws.primary
  identifier                      = format("rds-db-instance-multitenant-%s-%s-%s", split("-", var.primary_vpc_id)[1], local.database_id, (count.index + 1))
  cluster_identifier              = aws_rds_cluster.provisioning_rds_cluster_primary.id
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_type
  db_subnet_group_name            = "mattermost-provisioner-db-${var.primary_vpc_id}-postgresql"
  db_parameter_group_name         = aws_db_parameter_group.db_parameter_group_postgresql_primary.id
  preferred_maintenance_window    = var.preferred_maintenance_window
  apply_immediately               = var.apply_immediately
  monitoring_role_arn             = data.aws_iam_role.enhanced_monitoring.arn
  monitoring_interval             = var.monitoring_interval
  promotion_tier                  = count.index + 1
  performance_insights_enabled    = local.performance_insights_enabled
  performance_insights_kms_key_id = local.performance_insights_enabled ? (var.performance_kms_key_id_primary != "" ? var.performance_kms_key_id_primary : local.cluster_kms_key_arn_primary) : ""

  tags = merge(
    {
      "DatabaseType"                        = var.multitenant_tag,
      "MattermostCloudInstallationDatabase" = "PostgreSQL/Aurora"
    },
    var.tags,
  [var.enable_devops_guru ? { "devops-guru-default" = replace("${aws_rds_cluster.provisioning_rds_cluster_primary.cluster_identifier}-${count.index + 1}", "/rds-cluster/", "rds-db-instance") } : null]...)
}

resource "aws_rds_cluster" "provisioning_rds_cluster_secondary" {
  count                            = var.enable_global_cluster ? 1 : 0
  provider                         = aws.secondary
  cluster_identifier               = format("rds-cluster-multitenant-%s-%s-sec", split("-", var.secondary_vpc_id)[1], local.database_id)
  engine                           = var.engine
  engine_version                   = var.engine_version
  kms_key_id                       = local.cluster_kms_key_arn_secondary
  global_cluster_identifier        = var.enable_global_cluster ? aws_rds_global_cluster.global-cluster[0].id : ""
  final_snapshot_identifier        = "${var.final_snapshot_identifier_prefix}-${format("rds-cluster-multitenant-%s-%s-primary", split("-", var.secondary_vpc_id)[1], local.database_id)}"
  skip_final_snapshot              = var.skip_final_snapshot
  deletion_protection              = var.deletion_protection
  backup_retention_period          = var.backup_retention_period
  preferred_backup_window          = var.preferred_backup_window
  preferred_maintenance_window     = var.preferred_maintenance_window
  port                             = var.port
  db_subnet_group_name             = "mattermost-provisioner-db-${var.secondary_vpc_id}-postgresql"
  vpc_security_group_ids           = [data.aws_security_group.db_sg_secondary[0].id]
  storage_encrypted                = var.storage_encrypted
  apply_immediately                = var.apply_immediately
  db_cluster_parameter_group_name  = aws_rds_cluster_parameter_group.cluster_parameter_group_postgresql_secondary[0].id
  db_instance_parameter_group_name = aws_db_parameter_group.db_parameter_group_postgresql_secondary[0].id
  copy_tags_to_snapshot            = var.copy_tags_to_snapshot
  snapshot_identifier              = var.creation_snapshot_arn_secondary == "" ? null : var.creation_snapshot_arn_secondary
  allow_major_version_upgrade      = var.allow_major_version_upgrade
  enabled_cloudwatch_logs_exports  = var.enabled_cloudwatch_logs_exports


  tags = merge(
    {
      "Counter"                             = 0,
      "MultitenantDatabaseID"               = format("rds-cluster-multitenant-%s-%s-secondary", split("-", var.secondary_vpc_id)[1], local.database_id),
      "VpcID"                               = var.secondary_vpc_id,
      "DatabaseType"                        = var.multitenant_tag,
      "MattermostCloudInstallationDatabase" = "PostgreSQL/Aurora"
    },
    var.tags
  )
  lifecycle {
    ignore_changes = [
      tags["Counter"],
      replication_source_identifier
    ]
  }
}

resource "aws_rds_cluster_instance" "provisioning_rds_db_instance_secondary" {
  count                           = var.enable_global_cluster ? var.replica_min_secondary : 0
  provider                        = aws.secondary
  identifier                      = format("rds-db-instance-multitenant-%s-%s-sec-%s", split("-", var.secondary_vpc_id)[1], local.database_id, (count.index + 1))
  cluster_identifier              = aws_rds_cluster.provisioning_rds_cluster_secondary[0].id
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_type
  db_subnet_group_name            = "mattermost-provisioner-db-${var.secondary_vpc_id}-postgresql"
  db_parameter_group_name         = aws_db_parameter_group.db_parameter_group_postgresql_secondary[0].id
  preferred_maintenance_window    = var.preferred_maintenance_window
  apply_immediately               = var.apply_immediately
  monitoring_role_arn             = data.aws_iam_role.enhanced_monitoring.arn
  monitoring_interval             = var.monitoring_interval
  promotion_tier                  = count.index + 1
  performance_insights_enabled    = local.performance_insights_enabled
  performance_insights_kms_key_id = local.performance_insights_enabled ? (var.performance_kms_key_id_secondary != "" ? var.performance_kms_key_id_secondary : local.cluster_kms_key_arn_secondary) : ""

  tags = merge(
    {
      "DatabaseType"                        = var.multitenant_tag,
      "MattermostCloudInstallationDatabase" = "PostgreSQL/Aurora"
    },
    var.tags,
  [var.enable_devops_guru ? { "devops-guru-default" = replace("${aws_rds_cluster.provisioning_rds_cluster_secondary[0].cluster_identifier}-${count.index + 1}", "/rds-cluster/", "rds-db-instance") } : null]...)
}

/*
sleep 3 is a waiting time between tag Add/Remove and Devops Guru enable/disable.
This command will always run and "|| true will prevent it to broke when enabled_devops_guru is false and there's nothing to disable
The local exec is a temporary solution until terraform supports devops-guru https://github.com/hashicorp/terraform-provider-aws/issues/17919
*/
resource "null_resource" "enable_devops_guru_primary" {
  count = var.replica_min_primary
  provisioner "local-exec" {
    command = <<-EOF
      sleep 3 \
      && aws devops-guru update-resource-collection \
      --action ${var.enable_devops_guru == true ? "ADD" : "REMOVE"} \
      --resource-collection '{"Tags": [{"AppBoundaryKey": "devops-guru-default", "TagValues": ["${aws_rds_cluster.provisioning_rds_cluster_primary.cluster_identifier}-${count.index + 1}"]}]}' \
      || true
EOF
  }
  depends_on = [
    aws_rds_cluster_instance.provisioning_rds_db_instance_primary
  ]
  triggers = {
    enable_devops_guru = var.enable_devops_guru
  }
}

resource "null_resource" "enable_devops_guru_secondary" {
  count = var.enable_global_cluster ? var.replica_min_secondary : 0
  provisioner "local-exec" {
    command = <<-EOF
      sleep 3 \
      && aws devops-guru update-resource-collection \
      --action ${var.enable_devops_guru == true ? "ADD" : "REMOVE"} \
      --resource-collection '{"Tags": [{"AppBoundaryKey": "devops-guru-default", "TagValues": ["${aws_rds_cluster.provisioning_rds_cluster_secondary[0].cluster_identifier}-${count.index + 1}"]}]}' \
      || true
EOF
  }
  depends_on = [
    aws_rds_cluster_instance.provisioning_rds_db_instance_secondary
  ]
  triggers = {
    enable_devops_guru = var.enable_devops_guru
  }
}

resource "random_string" "db_cluster_identifier" {
  length  = 8
  special = false
  upper   = false

  lifecycle {
    ignore_changes = [
      special,
      upper,
    ]
  }
}

resource "aws_appautoscaling_target" "read_replica_count_primary" {
  max_capacity       = var.replica_scale_max
  min_capacity       = var.replica_scale_min
  resource_id        = "cluster:${aws_rds_cluster.provisioning_rds_cluster_primary.cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"
}

resource "aws_appautoscaling_target" "read_replica_count_secondary" {
  count              = var.enable_global_cluster ? 1 : 0
  provider           = aws.secondary
  max_capacity       = var.replica_scale_max
  min_capacity       = var.replica_scale_min
  resource_id        = "cluster:${aws_rds_cluster.provisioning_rds_cluster_secondary[0].cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"
}

resource "aws_appautoscaling_policy" "autoscaling_read_replica_count_primary" {
  name               = format("rds-target-metric-%s-%s", split("-", var.primary_vpc_id)[1], local.database_id)
  policy_type        = "TargetTrackingScaling"
  resource_id        = "cluster:${aws_rds_cluster.provisioning_rds_cluster_primary.cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.predefined_metric_type
    }

    scale_in_cooldown  = var.replica_scale_in_cooldown
    scale_out_cooldown = var.replica_scale_out_cooldown
    target_value       = var.predefined_metric_type == "RDSReaderAverageCPUUtilization" ? var.replica_scale_cpu : tonumber(local.max_connections) * 0.6
  }

  depends_on = [aws_appautoscaling_target.read_replica_count_primary]
}

resource "aws_appautoscaling_policy" "autoscaling_read_replica_count_secondary" {
  count              = var.enable_global_cluster ? 1 : 0
  provider           = aws.secondary
  name               = format("rds-target-metric-%s-%s", split("-", var.secondary_vpc_id)[1], local.database_id)
  policy_type        = "TargetTrackingScaling"
  resource_id        = "cluster:${aws_rds_cluster.provisioning_rds_cluster_secondary[0].cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.predefined_metric_type
    }

    scale_in_cooldown  = var.replica_scale_in_cooldown
    scale_out_cooldown = var.replica_scale_out_cooldown
    target_value       = var.predefined_metric_type == "RDSReaderAverageCPUUtilization" ? var.replica_scale_cpu : tonumber(local.max_connections) * 0.6
  }

  depends_on = [aws_appautoscaling_target.read_replica_count_secondary]
}

resource "aws_secretsmanager_secret" "master_password" {
  name = format("rds-cluster-multitenant-%s-%s", split("-", var.primary_vpc_id)[1], local.database_id)
}

resource "aws_secretsmanager_secret_version" "master_password" {
  secret_id     = aws_secretsmanager_secret.master_password.id
  secret_string = local.master_password
}

resource "aws_db_parameter_group" "db_parameter_group_postgresql_primary" {
  provider = aws.primary

  name_prefix = format("rds-cluster-multitenant-%s-%s-pg", split("-", var.primary_vpc_id)[1], local.database_id)
  family      = "aurora-postgresql13"

  parameter {
    apply_method = "pending-reboot"
    name         = "max_connections"
    value        = "{DBInstanceClassMemory/9531392}"
  }

  parameter {
    name  = "random_page_cost"
    value = var.random_page_cost
  }

  parameter {
    name  = "tcp_keepalives_count"
    value = var.tcp_keepalives_count
  }

  parameter {
    name  = "tcp_keepalives_idle"
    value = var.tcp_keepalives_idle
  }

  parameter {
    name  = "tcp_keepalives_interval"
    value = var.tcp_keepalives_interval
  }

  parameter {
    name  = "log_min_duration_statement"
    value = var.environment == "prod" ? 2000 : var.log_min_duration_statement
  }

  tags = merge(
    {
      "MattermostCloudInstallationDatabase" = "PostgreSQL/Aurora",
      "MultitenantDatabaseID"               = format("rds-cluster-multitenant-%s-%s", split("-", var.primary_vpc_id)[1], local.database_id)
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_rds_cluster_parameter_group" "cluster_parameter_group_postgresql_primary" {
  provider = aws.primary

  name_prefix = format("rds-cluster-multitenant-%s-%s-cluster-pg", split("-", var.primary_vpc_id)[1], local.database_id)
  family      = "aurora-postgresql13"


  parameter {
    apply_method = "pending-reboot"
    name         = "max_connections"
    value        = "{DBInstanceClassMemory/9531392}"
  }

  parameter {
    name  = "random_page_cost"
    value = var.random_page_cost
  }

  parameter {
    name  = "tcp_keepalives_count"
    value = var.tcp_keepalives_count
  }

  parameter {
    name  = "tcp_keepalives_idle"
    value = var.tcp_keepalives_idle
  }

  parameter {
    name  = "tcp_keepalives_interval"
    value = var.tcp_keepalives_interval
  }

  parameter {
    name  = "log_min_duration_statement"
    value = var.environment == "prod" ? 2000 : var.log_min_duration_statement
  }

  tags = merge(
    {
      "MattermostCloudInstallationDatabase" = "PostgreSQL/Aurora",
      "MultitenantDatabaseID"               = format("rds-cluster-multitenant-%s-%s", split("-", var.primary_vpc_id)[1], local.database_id)
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_parameter_group" "db_parameter_group_postgresql_secondary" {
  count    = var.enable_global_cluster ? 1 : 0
  provider = aws.secondary

  name_prefix = format("rds-cluster-multitenant-%s-%s-pg", split("-", var.primary_vpc_id)[1], local.database_id)
  family      = "aurora-postgresql13"

  parameter {
    apply_method = "pending-reboot"
    name         = "max_connections"
    value        = "{DBInstanceClassMemory/9531392}"
  }

  parameter {
    name  = "random_page_cost"
    value = var.random_page_cost
  }

  parameter {
    name  = "tcp_keepalives_count"
    value = var.tcp_keepalives_count
  }

  parameter {
    name  = "tcp_keepalives_idle"
    value = var.tcp_keepalives_idle
  }

  parameter {
    name  = "tcp_keepalives_interval"
    value = var.tcp_keepalives_interval
  }

  parameter {
    name  = "log_min_duration_statement"
    value = var.environment == "prod" ? 2000 : var.log_min_duration_statement
  }

  tags = merge(
    {
      "MattermostCloudInstallationDatabase" = "PostgreSQL/Aurora",
      "MultitenantDatabaseID"               = format("rds-cluster-multitenant-%s-%s", split("-", var.primary_vpc_id)[1], local.database_id)
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_rds_cluster_parameter_group" "cluster_parameter_group_postgresql_secondary" {
  count    = var.enable_global_cluster ? 1 : 0
  provider = aws.secondary

  name_prefix = format("rds-cluster-multitenant-%s-%s-cluster-pg", split("-", var.primary_vpc_id)[1], local.database_id)
  family      = "aurora-postgresql13"


  parameter {
    apply_method = "pending-reboot"
    name         = "max_connections"
    value        = "{DBInstanceClassMemory/9531392}"
  }

  parameter {
    name  = "random_page_cost"
    value = var.random_page_cost
  }

  parameter {
    name  = "tcp_keepalives_count"
    value = var.tcp_keepalives_count
  }

  parameter {
    name  = "tcp_keepalives_idle"
    value = var.tcp_keepalives_idle
  }

  parameter {
    name  = "tcp_keepalives_interval"
    value = var.tcp_keepalives_interval
  }

  parameter {
    name  = "log_min_duration_statement"
    value = var.environment == "prod" ? 2000 : var.log_min_duration_statement
  }

  tags = merge(
    {
      "MattermostCloudInstallationDatabase" = "PostgreSQL/Aurora",
      "MultitenantDatabaseID"               = format("rds-cluster-multitenant-%s-%s", split("-", var.primary_vpc_id)[1], local.database_id)
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "rds-cluster-log-group" {
  name       = format("rds-cluster-multitenant-%s-%s/postgresql", split("-", var.primary_vpc_id)[1], local.database_id)
  depends_on = [aws_rds_cluster.provisioning_rds_cluster_primary]
}
