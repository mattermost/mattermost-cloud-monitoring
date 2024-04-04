resource "aws_security_group" "cnc_to_awat_db" {
  name                   = "cnc_awat_db_access"
  description            = "Allow K8s C&C to access RDS AWAT Postgres"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.cnc_cluster.outputs.workers_security_group]
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
    Name    = "AWAT DB SG"
    Created = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

}

resource "aws_db_subnet_group" "subnets_db" {
  name       = "awat_db_subnetgroup"
  subnet_ids = var.private_subnets

  tags = {
    Name = "AWAT DB subnet group"
  }

}


module "aurora-cluster" {
  source                                = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/aurora-cluster?ref=v1.7.11"
  cluster_identifier                    = var.awat_db_cluster_identifier
  cluster_instance_identifier           = var.awat_db_cluster_instance_identifier
  ca_cert_identifier                    = var.awat_ca_cert_identifier
  replica_min                           = var.awat_replica_min
  enable_rds_reader                     = var.enable_awat_read_replica
  vpc_id                                = var.vpc_id
  environment                           = var.environment
  engine                                = var.awat_db_cluster_engine
  engine_mode                           = var.awat_db_cluster_engine_mode
  engine_version                        = var.awat_db_cluster_engine_version
  instance_type                         = var.awat_db_cluster_instance_type
  username                              = var.awat_db_username
  password                              = var.awat_db_password
  final_snapshot_identifier_prefix      = "awat-final-${var.awat_db_cluster_identifier}-${local.timestamp_now}"
  skip_final_snapshot                   = false
  deletion_protection                   = var.awat_db_deletion_protection
  backup_retention_period               = var.awat_db_backup_retention_period
  preferred_backup_window               = var.awat_db_backup_window
  preferred_maintenance_window          = var.awat_db_maintenance_window
  storage_encrypted                     = var.awat_cluster_storage_encrypted
  apply_immediately                     = var.awat_apply_immediately
  copy_tags_to_snapshot                 = var.awat_copy_tags_to_snapshot
  enabled_cloudwatch_logs_exports       = var.awat_enabled_cloudwatch_logs_exports
  monitoring_interval                   = var.awat_monitoring_interval
  performance_insights_enabled          = var.awat_performance_insights_enabled
  performance_insights_retention_period = var.awat_performance_insights_enabled ? var.awat_performance_insights_retention_period : null
  service_name                          = var.awat_service_name
  kms_key                               = var.awat_kms_key
  vpc_security_group_ids                = [aws_security_group.cnc_to_awat_db.id]
  aurora_family                         = var.awat_aurora_family
  db_subnet_group_name                  = aws_db_subnet_group.subnets_db.name
  min_capacity                          = var.awat_min_capacity
  max_capacity                          = var.awat_max_capacity
  enable_rds_alerting                   = var.awat_enable_rds_alerting
  allow_major_version_upgrade           = var.allow_major_version_upgrade
}
