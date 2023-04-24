resource "aws_security_group" "blapi_cec_to_postgres" {
  name                   = "blapi_cec_to_postgres"
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

resource "aws_security_group" "connect-rds-ec2" {
  name                   = "connect_rds_ec2"
  description            = "Allow ec2 bastion to access RDS Postgres"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  ingress {
    from_port       = 5432
    protocol        = "TCP"
    to_port         = 5432
    security_groups = [var.connect_ec2_rds_security_group]
  }

  tags = {}

}

resource "aws_db_subnet_group" "blapi_subnets_db" {
  name       = "blapi_cloud_db_subnetgroup"
  subnet_ids = var.private_subnets

  tags = {
    Name = "Blapi Cloud DB subnet group"
  }

}

module "aurora-cluster" {
  source                                = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/aurora-cluster?ref=v1.6.17"
  cluster_identifier                    = var.blapi_db_cluster_identifier
  cluster_instance_identifier           = var.blapi_db_cluster_instance_identifier
  replica_min                           = var.blapi_replica_min
  enable_rds_reader                     = var.enable_blapi_read_replica
  vpc_id                                = var.vpc_id
  environment                           = var.environment
  engine                                = var.blapi_db_cluster_engine
  engine_mode                           = var.blapi_db_cluster_engine_mode
  engine_version                        = var.blapi_db_cluster_engine_version
  instance_type                         = var.blapi_db_cluster_instance_type
  username                              = var.db_username
  password                              = var.db_password
  final_snapshot_identifier_prefix      = "blapi-final-${var.blapi_db_cluster_identifier}-${local.timestamp_now}"
  skip_final_snapshot                   = false
  deletion_protection                   = var.db_deletion_protection
  backup_retention_period               = var.db_backup_retention_period
  preferred_backup_window               = var.db_backup_window
  preferred_maintenance_window          = var.db_maintenance_window
  storage_encrypted                     = var.blapi_cluster_storage_encrypted
  apply_immediately                     = var.blapi_apply_immediately
  copy_tags_to_snapshot                 = var.blapi_copy_tags_to_snapshot
  enabled_cloudwatch_logs_exports       = var.blapi_enabled_cloudwatch_logs_exports
  monitoring_interval                   = var.blapi_monitoring_interval
  performance_insights_enabled          = var.blapi_performance_insights_enabled
  performance_insights_retention_period = var.blapi_performance_insights_retention_period
  service_name                          = var.blapi_service_name
  kms_key                               = var.blapi_kms_key
  vpc_security_group_ids                = [aws_security_group.blapi_cec_to_postgres.id, aws_security_group.connect-rds-ec2.id]
  aurora_family                         = var.blapi_aurora_family
  db_subnet_group_name                  = aws_db_subnet_group.blapi_subnets_db.name
  min_capacity                          = var.blapi_min_capacity
  max_capacity                          = var.blapi_max_capacity
}
