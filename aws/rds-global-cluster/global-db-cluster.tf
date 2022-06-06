resource "aws_rds_global_cluster" "global-cluster" {
  global_cluster_identifier = var.global_cluster_identifier
  engine                    = var.engine
  engine_version            = var.engine_version
  database_name             = var.database_name
}

resource "aws_rds_cluster" "primary" {
  provider                  = aws.primary
  engine                    = aws_rds_global_cluster.global-cluster.engine
  engine_version            = aws_rds_global_cluster.global-cluster.engine_version
  cluster_identifier        = var.primary_cluster_identifier
  master_username           = var.master_username
  master_password           = var.master_password
  database_name             = var.database_name
  global_cluster_identifier = aws_rds_global_cluster.global-cluster.id
  db_subnet_group_name      = var.primary_db_subnet_group_name
  backup_retention_period   = var.backup_retention_period
  preferred_backup_window   = var.preferred_backup_window
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier
  tags                      = var.tags
}

resource "aws_rds_cluster_instance" "primary" {
  count                = var.primary_instances_count
  provider             = aws.primary
  identifier           = "${var.primary_cluster_identifier}-${count.index}"
  cluster_identifier   = aws_rds_cluster.primary.id
  instance_class       = var.instance_class
  db_subnet_group_name = var.primary_db_subnet_group_name
  tags                 = var.tags
}

resource "aws_rds_cluster" "secondary" {
  provider                  = aws.secondary
  engine                    = aws_rds_global_cluster.global-cluster.engine
  engine_version            = aws_rds_global_cluster.global-cluster.engine_version
  cluster_identifier        = var.secondary_cluster_identifier
  global_cluster_identifier = aws_rds_global_cluster.global-cluster.id
  db_subnet_group_name      = var.secondary_db_subnet_group_name
  tags                      = var.tags
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier

   depends_on = [
    aws_rds_cluster.primary
  ]
}

resource "aws_rds_cluster_instance" "secondary" {
  count                = var.secondary_instances_count
  provider             = aws.secondary
  identifier           = "${var.secondary_cluster_identifier}-${count.index}"
  cluster_identifier   = aws_rds_cluster.secondary.id
  instance_class       = var.instance_class
  db_subnet_group_name = var.secondary_db_subnet_group_name

  depends_on = [
    aws_rds_cluster_instance.primary
  ]
}
