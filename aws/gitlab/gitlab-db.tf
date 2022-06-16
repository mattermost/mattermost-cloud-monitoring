resource "aws_security_group" "gitlab_to_postgress" {
  name                   = "gitlab_to_postgress"
  description            = "Allow gitlab cluster to access RDS Postgres"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.gitlab_security_group]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Gitlab Postgress DB Security Group"
  }
}

resource "aws_db_subnet_group" "subnets_db" {
  name       = "gitlab_db_subnet_group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "Gitlab DB Subnet Group"
  }

}

resource "aws_db_instance" "gitlab" {
  identifier                  = var.db_identifier
  allocated_storage           = var.allocated_db_storage
  storage_type                = "gp2"
  engine                      = "postgres"
  engine_version              = var.db_engine_version
  instance_class              = var.db_instance_class
  db_name                     = var.db_name
  username                    = var.db_username
  password                    = var.db_password
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  apply_immediately           = true
  backup_retention_period     = var.db_backup_retention_period
  backup_window               = var.db_backup_window
  db_subnet_group_name        = aws_db_subnet_group.subnets_db.name
  vpc_security_group_ids      = [aws_security_group.gitlab_to_postgress.id]
  deletion_protection         = true
  final_snapshot_identifier   = "gitlab-final-${var.db_name}"
  skip_final_snapshot         = false
  maintenance_window          = var.db_maintenance_window
  publicly_accessible         = false
  snapshot_identifier         = var.snapshot_identifier
  storage_encrypted           = var.storage_encrypted
  multi_az                    = var.multi_az

  tags = {
    Name = "Gitlab DB Instance"
  }
}
