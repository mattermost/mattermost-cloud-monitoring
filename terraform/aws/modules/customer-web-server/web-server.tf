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
  name                        = var.cws_db_name
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

  tags = {
    Name         = "customer-web-server"
    Environment  = var.environment
    DatabaseType = "cws"
  }
}
