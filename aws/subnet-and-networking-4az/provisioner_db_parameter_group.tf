resource "aws_db_parameter_group" "db_parameter_group" {

  count  = var.deploy_cluster_parameter_group ? 1 : 0
  name   = "mattermost-provisioner-rds-pg"
  family = "aurora-mysql5.7"

  tags = merge(
    {
      "MattermostCloudInstallationDatabase" = "MYSQL/Aurora"
    },
    var.tags
  )
}

resource "aws_rds_cluster_parameter_group" "cluster_parameter_group" {

  count  = var.deploy_cluster_parameter_group ? 1 : 0
  name   = "mattermost-provisioner-rds-cluster-pg"
  family = "aurora-mysql5.7"

  parameter {
    apply_method = "pending-reboot"
    name         = "binlog_format"
    value        = "MIXED"
  }
  tags = merge(
    {
      "MattermostCloudInstallationDatabase" = "MYSQL/Aurora"
    },
    var.tags
  )

}


