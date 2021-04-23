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

resource "aws_db_instance" "awat" {
  identifier                  = var.awat_db_identifier
  allocated_storage           = var.allocated_db_storage
  storage_type                = var.awat_db_storage_type
  engine                      = "postgres"
  engine_version              = var.awat_db_engine_version
  instance_class              = var.awat_db_instance_class
  name                        = var.awat_db_name
  username                    = var.awat_db_username
  password                    = var.awat_db_password
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = true
  apply_immediately           = true
  backup_retention_period     = var.awat_db_backup_retention_period
  backup_window               = var.awat_db_backup_window
  db_subnet_group_name        = aws_db_subnet_group.subnets_db.name
  vpc_security_group_ids      = [aws_security_group.cnc_to_awat_db.id]
  deletion_protection         = var.awat_db_deletion_protection
  final_snapshot_identifier   = "awat-final-${var.awat_db_name}-${local.timestamp_now}"
  skip_final_snapshot         = false
  maintenance_window          = var.awat_db_maintenance_window
  publicly_accessible         = false
  snapshot_identifier         = var.awat_snapshot_identifier
  storage_encrypted           = var.storage_encrypted
  availability_zone           = var.awat_db_master_az

  tags = {
    Name         = "AWAT"
    Environment  = var.environment
    DatabaseType = "awat"
  }

  lifecycle {
    ignore_changes = [
      final_snapshot_identifier,
    ]
  }
}

resource "aws_db_instance" "awat_read_replica" {
  count = var.enable_awat_read_replica ? 1 : 0

  identifier                  = local.db_identifier_read_replica
  name                        = var.awat_db_name
  instance_class              = var.awat_db_instance_class
  storage_type                = var.awat_db_storage_type
  storage_encrypted           = var.storage_encrypted
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  apply_immediately           = true
  deletion_protection         = var.awat_db_deletion_protection

  # networking
  vpc_security_group_ids = [aws_security_group.cnc_to_awat_db.id]
  publicly_accessible    = false
  availability_zone      = var.awat_db_read_replica_az

  # backup & maintenance
  maintenance_window = var.awat_db_maintenance_window

  # replication read replica
  replicate_source_db = aws_db_instance.awat.identifier

  tags = {
    Name         = "AWAT"
    Environment  = var.environment
    DatabaseType = "awat"
  }

  lifecycle {
    ignore_changes = [
      final_snapshot_identifier,
    ]
  }
}
