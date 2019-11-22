provider "aws" {
  region = var.region
}

resource "aws_security_group" "cec_to_postgress" {
  name        = "cec_to_postgress"
  description = "Allow K8s C&C to access RDS Postgres"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.cidr_block_cec_cluster
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
  db_subnet_group_name        = var.db_subnet_group_name
  vpc_security_group_ids      = [aws_security_group.cec_to_postgress.id]
  deletion_protection         = true
  snapshot_identifier         = "provisioner"
  final_snapshot_identifier   = "provisioner-final"
  kip_final_snapshot          = false
  maintenance_window          = var.db_maintenance_window
  publicly_accessible         = false
  snapshot_identifier         = var.snapshot_identifier
}
