data "aws_region" "current" {}

data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    bucket = "terraform-cloud-monitoring-state-bucket-${var.environment}"
    key    = "${data.aws_region.current.name}/mattermost-central-command-control"
    region = "us-east-1"
  }
}

resource "aws_security_group" "cws_postgres_sg" {
  name                   = "cws_postgres_sg"
  description            = "postgres SG for customer web server"
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
    Name    = "postgres SG customer web server"
    Created = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

}

resource "aws_db_subnet_group" "cws_subnets_db" {
  name       = "cws_subnetgroup"
  subnet_ids = var.private_subnets

  tags = {
    Name = "customer web server DB subnet group"
  }

}

resource "aws_db_instance" "cws_postgres" {
  identifier                  = var.cws_db_identifier
  allocated_storage           = var.cws_allocated_db_storage
  storage_type                = "gp2"
  engine                      = "postgres"
  engine_version              = var.cws_db_engine_version
  instance_class              = var.cws_db_instance_class
  name                        = var.cws_db_name
  username                    = var.cws_db_username
  password                    = var.cws_db_password
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  apply_immediately           = true
  backup_retention_period     = var.cws_db_backup_retention_period
  backup_window               = var.cws_db_backup_window
  db_subnet_group_name        = aws_db_subnet_group.cws_subnets_db.name
  vpc_security_group_ids      = [aws_security_group.cws_postgres_sg.id]
  deletion_protection         = true
  final_snapshot_identifier   = "customer-web-server-final-${var.cws_db_name}"
  skip_final_snapshot         = false
  maintenance_window          = var.cws_db_maintenance_window
  publicly_accessible         = false
  availability_zone           = var.cws_db_master_az
  # snapshot_identifier         = var.cws_snapshot_identifier
  storage_encrypted = var.cws_storage_encrypted

  tags = {
    Name         = "customer-web-server"
    Environment  = var.environment
    DatabaseType = "cws"
  }
}

resource "aws_db_instance" "cws_postgres_read_replica" {
  count = var.enable_cws_read_replica ? 1 : 0

  identifier                  = local.db_identifier_read_replica
  instance_class              = var.cws_db_instance_class
  storage_type                = "gp2"
  storage_encrypted           = var.cws_storage_encrypted
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  apply_immediately           = true
  deletion_protection         = true

  # networking
  vpc_security_group_ids = [aws_security_group.cws_postgres_sg.id]
  publicly_accessible    = false
  availability_zone      = var.cws_db_read_replica_az

  # backup & maintenance
  maintenance_window = var.cws_db_maintenance_window

  # replication read replica
  replicate_source_db = aws_db_instance.cws_postgres.identifier

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period

  tags = {
    Name         = "customer-web-server"
    Environment  = var.environment
    DatabaseType = "cws"
  }
}


module "aurora-cluster" {
  source                                = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/aurora-cluster?ref=v1.5.37"
  cluster_identifier                    = var.cws_db_cluster_identifier
  cluster_instance_identifier           = var.cws_db_cluster_instance_identifier
  replica_min                           = var.cws_replica_min
  vpc_id                                = var.vpc_id
  environment                           = var.environment
  engine                                = var.cws_db_cluster_engine
  engine_mode                           = var.cws_db_cluster_engine_mode
  engine_version                        = var.cws_db_cluster_engine_version
  instance_type                         = var.cws_db_cluster_instance_type
  username                              = var.cws_db_username
  password                              = var.cws_db_password
  final_snapshot_identifier_prefix      = "cws-final-${var.cws_db_cluster_identifier}-${local.timestamp_now}"
  skip_final_snapshot                   = false
  deletion_protection                   = var.cws_db_deletion_protection
  backup_retention_period               = var.cws_db_backup_retention_period
  preferred_backup_window               = var.cws_db_backup_window
  preferred_maintenance_window          = var.cws_db_maintenance_window
  storage_encrypted                     = var.cws_cluster_storage_encrypted
  apply_immediately                     = var.cws_apply_immediately
  copy_tags_to_snapshot                 = var.cws_copy_tags_to_snapshot
  enabled_cloudwatch_logs_exports       = var.cws_enabled_cloudwatch_logs_exports
  monitoring_interval                   = var.cws_monitoring_interval
  performance_insights_enabled          = var.cws_performance_insights_enabled
  performance_insights_retention_period = var.cws_performance_insights_retention_period
  service_name                          = var.cws_service_name
  kms_key                               = var.cws_kms_key
  vpc_security_group_ids                = [aws_security_group.cws_postgres_sg.id]
  aurora_family                         = var.cws_aurora_family
  db_subnet_group_name                  = aws_db_subnet_group.cws_subnets_db.name
  min_capacity                          = var.cws_min_capacity
  max_capacity                          = var.cws_max_capacity
}
