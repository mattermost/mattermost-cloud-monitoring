resource "aws_security_group" "cnc_to_elrond_postgress" {
  name                   = "cnc_to_elrond_postgress"
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
    Name    = "Elrond DB SG"
    Created = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

}

resource "aws_db_subnet_group" "subnets_db" {
  name       = "elrond_db_subnetgroup"
  subnet_ids = var.private_subnets

  tags = {
    Name = "Elrond DB subnet group"
  }

}

module "aurora-cluster" {
  source                                = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/aurora-cluster?ref=v1.7.93"
  cluster_identifier                    = var.elrond_db_cluster_identifier
  cluster_instance_identifier           = var.elrond_db_cluster_instance_identifier
  ca_cert_identifier                    = var.elrond_ca_cert_identifier
  replica_min                           = var.elrond_replica_min
  enable_rds_reader                     = var.enable_elrond_read_replica
  vpc_id                                = var.vpc_id
  environment                           = var.environment
  engine                                = var.elrond_db_cluster_engine
  engine_mode                           = var.elrond_db_cluster_engine_mode
  engine_version                        = var.elrond_db_cluster_engine_version
  instance_type                         = var.elrond_db_cluster_instance_type
  username                              = var.db_username
  password                              = var.db_password
  iam_database_authentication_enabled   = var.iam_database_authentication_enabled
  final_snapshot_identifier_prefix      = "elrond-final-${var.elrond_db_cluster_identifier}-${local.timestamp_now}"
  skip_final_snapshot                   = false
  deletion_protection                   = var.db_deletion_protection
  backup_retention_period               = var.db_backup_retention_period
  preferred_backup_window               = var.db_backup_window
  preferred_maintenance_window          = var.db_maintenance_window
  storage_encrypted                     = var.elrond_cluster_storage_encrypted
  apply_immediately                     = var.elrond_apply_immediately
  copy_tags_to_snapshot                 = var.elrond_copy_tags_to_snapshot
  enabled_cloudwatch_logs_exports       = var.elrond_enabled_cloudwatch_logs_exports
  monitoring_interval                   = var.elrond_monitoring_interval
  performance_insights_enabled          = var.elrond_performance_insights_enabled
  performance_insights_retention_period = var.elrond_performance_insights_enabled ? var.elrond_performance_insights_retention_period : null
  service_name                          = var.elrond_service_name
  kms_key                               = var.elrond_kms_key
  vpc_security_group_ids                = [aws_security_group.cnc_to_elrond_postgress.id]
  aurora_family                         = var.elrond_aurora_family
  db_subnet_group_name                  = aws_db_subnet_group.subnets_db.name
  min_capacity                          = var.elrond_min_capacity
  max_capacity                          = var.elrond_max_capacity
  enable_rds_alerting                   = var.elrond_enable_rds_alerting
  allow_major_version_upgrade           = var.allow_major_version_upgrade
}
