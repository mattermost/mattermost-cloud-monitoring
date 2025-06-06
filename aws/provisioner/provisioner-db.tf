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

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.teleport_cidr
    description = "Allow the Teleport DB Service"
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.grafana_cidr
    description = "Centralised Grafana"
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.gitlab_cidr
    description = "Gitlab Access for Provisioner DB"
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.grant_privileges_to_schemas_sg]
    description     = "Grant Privileges to Schemas Lambda access for Provisioner DB"
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

resource "aws_security_group_rule" "provisioner_calico_ingress" {
  count = var.is_calico_enabled ? 1 : 0

  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = var.calico_cidr
  security_group_id = aws_security_group.cec_to_postgress.id
  description       = "Allow calico overlay network"
}

resource "aws_db_subnet_group" "subnets_db" {
  name       = "cloud_db_subnetgroup"
  subnet_ids = var.private_subnets

  tags = {
    Name = "Cloud DB subnet group"
  }

}

data "aws_secretsmanager_secret" "provisioner" {
  name = format("%s-%s", var.provisioner_service_name, var.environment)
}

data "aws_secretsmanager_secret_version" "provisioner" {
  secret_id = data.aws_secretsmanager_secret.provisioner.id
}

module "aurora-cluster" {
  source                                = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/aurora-cluster?ref=v1.7.93"
  cluster_identifier                    = var.provisioner_db_cluster_identifier
  cluster_instance_identifier           = var.provisioner_db_cluster_instance_identifier
  ca_cert_identifier                    = var.provisioner_ca_cert_identifier
  replica_min                           = var.provisioner_replica_min
  enable_rds_reader                     = var.enable_provisioner_read_replica
  vpc_id                                = var.vpc_id
  environment                           = var.environment
  engine                                = var.provisioner_db_cluster_engine
  engine_mode                           = var.provisioner_db_cluster_engine_mode
  engine_version                        = var.provisioner_db_cluster_engine_version
  instance_type                         = var.provisioner_db_cluster_instance_type
  username                              = var.db_username
  password                              = data.aws_secretsmanager_secret_version.provisioner.secret_string
  iam_database_authentication_enabled   = var.iam_database_authentication_enabled
  final_snapshot_identifier_prefix      = "provisioner-final-${var.provisioner_db_cluster_identifier}-${local.timestamp_now}"
  skip_final_snapshot                   = false
  deletion_protection                   = var.db_deletion_protection
  backup_retention_period               = var.db_backup_retention_period
  preferred_backup_window               = var.db_backup_window
  preferred_maintenance_window          = var.db_maintenance_window
  storage_encrypted                     = var.provisioner_cluster_storage_encrypted
  apply_immediately                     = var.provisioner_apply_immediately
  copy_tags_to_snapshot                 = var.provisioner_copy_tags_to_snapshot
  enabled_cloudwatch_logs_exports       = var.provisioner_enabled_cloudwatch_logs_exports
  monitoring_interval                   = var.provisioner_monitoring_interval
  performance_insights_enabled          = var.provisioner_performance_insights_enabled
  performance_insights_retention_period = var.provisioner_performance_insights_enabled ? var.provisioner_performance_insights_retention_period : null
  service_name                          = var.provisioner_service_name
  kms_key                               = var.provisioner_kms_key
  vpc_security_group_ids                = [aws_security_group.cec_to_postgress.id]
  aurora_family                         = var.provisioner_aurora_family
  db_subnet_group_name                  = aws_db_subnet_group.subnets_db.name
  min_capacity                          = var.provisioner_min_capacity
  max_capacity                          = var.provisioner_max_capacity
  enable_rds_alerting                   = var.provisioner_enable_rds_alerting
  allow_major_version_upgrade           = var.allow_major_version_upgrade
}
