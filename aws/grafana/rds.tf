resource "aws_security_group" "grafana_cec_to_postgres" {
  name                   = "grafana_cec_to_postgres"
  description            = "Allow K8s C&C to access RDS Postgres"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.cluster.outputs.workers_security_group]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.cloud_vpn_cidr
    description = "CLOUD VPN"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "Cloud DB SG"
    Created = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

}

resource "aws_security_group_rule" "grafana_calico_ingress" {
  count = var.is_calico_enabled ? 1 : 0

  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = var.calico_cidr
  security_group_id = aws_security_group.grafana_cec_to_postgres.id
  description       = "Allow calico overlay network"
}

resource "aws_db_subnet_group" "grafana_subnets_db" {
  name       = "grafana_cloud_db_subnetgroup"
  subnet_ids = var.private_subnets

  tags = {
    Name = "grafana Cloud DB subnet group"
  }

}

data "aws_secretsmanager_secret" "grafana" {
  name = format("%s-%s", var.grafana_service_name, var.environment)
}

data "aws_secretsmanager_secret_version" "grafana" {
  secret_id = data.aws_secretsmanager_secret.grafana.id
}


module "aurora-cluster" {
  source                                = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/aurora-cluster?ref=v1.7.5"
  cluster_identifier                    = var.grafana_db_cluster_identifier
  cluster_instance_identifier           = var.grafana_db_cluster_instance_identifier
  ca_cert_identifier                    = var.grafana_ca_cert_identifier
  replica_min                           = var.grafana_replica_min
  enable_rds_reader                     = var.enable_grafana_read_replica
  vpc_id                                = var.vpc_id
  environment                           = var.environment
  engine                                = var.grafana_db_cluster_engine
  engine_mode                           = var.grafana_db_cluster_engine_mode
  engine_version                        = var.grafana_db_cluster_engine_version
  instance_type                         = var.grafana_db_cluster_instance_type
  username                              = var.db_username
  password                              = data.aws_secretsmanager_secret_version.grafana.secret_string
  final_snapshot_identifier_prefix      = "grafana-final-${var.grafana_db_cluster_identifier}-${local.timestamp_now}"
  skip_final_snapshot                   = false
  deletion_protection                   = var.db_deletion_protection
  backup_retention_period               = var.db_backup_retention_period
  preferred_backup_window               = var.db_backup_window
  preferred_maintenance_window          = var.db_maintenance_window
  storage_encrypted                     = var.grafana_cluster_storage_encrypted
  apply_immediately                     = var.grafana_apply_immediately
  copy_tags_to_snapshot                 = var.grafana_copy_tags_to_snapshot
  enabled_cloudwatch_logs_exports       = var.grafana_enabled_cloudwatch_logs_exports
  monitoring_interval                   = var.grafana_monitoring_interval
  performance_insights_enabled          = var.grafana_performance_insights_enabled
  performance_insights_retention_period = var.grafana_performance_insights_enabled ? var.grafana_performance_insights_retention_period : null
  service_name                          = var.grafana_service_name
  kms_key                               = var.grafana_kms_key
  vpc_security_group_ids                = [aws_security_group.grafana_cec_to_postgres.id]
  aurora_family                         = var.grafana_aurora_family
  db_subnet_group_name                  = aws_db_subnet_group.grafana_subnets_db.name
  min_capacity                          = var.grafana_min_capacity
  max_capacity                          = var.grafana_max_capacity
  enable_rds_alerting                   = var.grafana_enable_rds_alerting
}
