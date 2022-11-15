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

resource "aws_db_instance" "elrond" {
  identifier                  = var.db_identifier
  allocated_storage           = var.allocated_db_storage
  storage_type                = "gp2"
  engine                      = "postgres"
  engine_version              = var.db_engine_version
  instance_class              = var.db_instance_class
  name                        = var.db_name
  username                    = var.db_username
  password                    = var.db_password
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  apply_immediately           = true
  backup_retention_period     = var.db_backup_retention_period
  backup_window               = var.db_backup_window
  db_subnet_group_name        = aws_db_subnet_group.subnets_db.name
  vpc_security_group_ids      = [aws_security_group.cnc_to_elrond_postgress.id]
  deletion_protection         = var.db_deletion_protection
  final_snapshot_identifier   = "elrond-final-${var.db_name}-${local.timestamp_now}"
  skip_final_snapshot         = false
  maintenance_window          = var.db_maintenance_window
  publicly_accessible         = false
  snapshot_identifier         = var.snapshot_identifier
  storage_encrypted           = var.storage_encrypted
  availability_zone           = var.db_master_az

  tags = {
    Name         = "Elrond"
    Environment  = var.environment
    DatabaseType = "elrond"
  }

  lifecycle {
    ignore_changes = [
      final_snapshot_identifier,
    ]
  }
}

resource "aws_db_instance" "elrond_read_replica" {
  count = var.enable_elrond_read_replica ? 1 : 0

  identifier                  = local.db_identifier_read_replica
  instance_class              = var.db_instance_class
  storage_type                = "gp2"
  storage_encrypted           = var.storage_encrypted
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  apply_immediately           = true
  deletion_protection         = var.db_deletion_protection

  # networking
  vpc_security_group_ids = [aws_security_group.cnc_to_elrond_postgress.id]
  publicly_accessible    = false
  availability_zone      = var.db_read_replica_az

  # backup & maintenance
  maintenance_window = var.db_maintenance_window

  # replication read replica
  replicate_source_db = aws_db_instance.elrond.identifier

  tags = {
    Name         = "Elrond"
    Environment  = var.environment
    DatabaseType = "elrond"
  }

  lifecycle {
    ignore_changes = [
      final_snapshot_identifier,
    ]
  }
}

module "aurora-cluster" {
  source                                = "github.com/stafot/mattermost-cloud-monitoring.git//aws/aurora-cluster?ref=CLD-4009"
  cluster_identifier                    = var.elrond_db_cluster_identifier
  cluster_instance_identifier           = var.elrond_db_cluster_instance_identifier
  replica_min                           = var.elrond_replica_min
  vpc_id                                = var.vpc_id
  environment                           = var.environment
  engine                                = var.elrond_db_cluster_engine
  engine_mode                           = var.elrond_db_cluster_engine_mode
  engine_version                        = var.elrond_db_cluster_engine_version
  instance_type                         = var.elrond_db_cluster_instance_type
  username                              = var.db_username
  password                              = var.db_password
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
  performance_insights_retention_period = var.elrond_performance_insights_retention_period
  service_name                          = var.elrond_service_name
  kms_key                               = var.elrond_kms_key
  vpc_security_group_ids                = [aws_security_group.cnc_to_elrond_postgress.id]
  aurora_family                         = var.elrond_aurora_family
  db_subnet_group_name                  = aws_db_subnet_group.subnets_db.name
  min_capacity                          = var.elrond_min_capacity
  max_capacity                          = var.elrond_max_capacity
}
