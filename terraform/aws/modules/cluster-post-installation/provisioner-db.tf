provider "aws" {
  region = var.region
}

data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    bucket = "terraform-cloud-monitoring-state-bucket-${var.environment}"
    key    = "mattermost-central-command-control"
    region = "us-east-1"
  }
}

resource "aws_security_group" "cec_to_postgress" {
  name                   = "cec_to_postgress"
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

resource "aws_db_subnet_group" "subnets_db" {
  name       = "cloud_db_subnetgroup"
  subnet_ids = var.private_subnets

  tags = {
    Name = "Cloud DB subnet group"
  }

}

resource "aws_db_instance" "provisioner" {
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
  vpc_security_group_ids      = [aws_security_group.cec_to_postgress.id]
  deletion_protection         = true
  final_snapshot_identifier   = "provisioner-final-${var.db_name}"
  skip_final_snapshot         = false
  maintenance_window          = var.db_maintenance_window
  publicly_accessible         = false
  snapshot_identifier         = var.snapshot_identifier
  storage_encrypted           = var.storage_encrypted

  tags = {
    Name        = "Provisioner"
    Environment = var.environment
  }
}
