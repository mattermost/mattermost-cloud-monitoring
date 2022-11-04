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

resource "aws_db_subnet_group" "blapi_subnets_db" {
  name       = "blapi_cloud_db_subnetgroup"
  subnet_ids = var.private_subnets

  tags = {
    Name = "Blapi Cloud DB subnet group"
  }

}

resource "aws_db_instance" "blapi" {
  identifier                            = var.db_identifier
  allocated_storage                     = var.allocated_db_storage
  storage_type                          = var.storage_type
  engine                                = "postgres"
  engine_version                        = var.db_engine_version
  instance_class                        = var.db_instance_class
  name                                  = var.db_name
  username                              = var.db_username
  password                              = var.db_password
  allow_major_version_upgrade           = false
  auto_minor_version_upgrade            = true
  apply_immediately                     = true
  backup_retention_period               = var.db_backup_retention_period
  backup_window                         = var.db_backup_window
  db_subnet_group_name                  = aws_db_subnet_group.blapi_subnets_db.name
  vpc_security_group_ids                = [aws_security_group.blapi_cec_to_postgres.id]
  deletion_protection                   = var.db_deletion_protection
  final_snapshot_identifier             = "blapi-final-${var.db_name}-${local.timestamp_now}"
  skip_final_snapshot                   = false
  maintenance_window                    = var.db_maintenance_window
  publicly_accessible                   = false
  snapshot_identifier                   = var.snapshot_identifier
  storage_encrypted                     = var.storage_encrypted
  availability_zone                     = var.db_writer_az
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period

  tags = {
    Name         = "Blapi"
    Environment  = var.environment
    DatabaseType = "blapi"
  }

  lifecycle {
    ignore_changes = [
      final_snapshot_identifier,
    ]
  }
}

#module "aurora-cluster" {
#
#}
