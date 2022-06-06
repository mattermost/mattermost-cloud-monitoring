module "global-db-cluster-test" {
  source                               = "git::https://github.com/mattermost/mattermost-cloud-monitoring.git//aws/rds-global-cluster?ref=v1.0.0"
  source_region                        = "us-east-1"  # use your desired source region
  target_region                        = "us-west-2"  # use your desired target region
  global_cluster_identifier            = "global-test"
  primary_cluster_identifier           = "test-primary-cluster"
  secondary_cluster_identifier         = "test-secondary-cluster"
  engine                               = "aurora"
  engine_version                       = "5.6.mysql_aurora.1.22.2"
  database_name                        = "testdatabase"
  master_username                      = "username"
  master_password                      = "secretpassword" # MasterUserPassword should be >= 8 characters.
  primary_db_subnet_group_name         = "subnet-group-name-for-source-region"
  secondary_db_subnet_group_name       = "subnet-group-name-for-target-region"
  instance_class                       = "db.r4.large"
  backup_retention_period              = 5
  preferred_backup_window              = "07:00-09:00"
  skip_final_snapshot                  = true
  final_snapshot_identifier            = "test-primary-cluster-final"
  tags                                 = {
                                      "Owner"	      = "my-team",
                                      "Terraform"   = "true",
                                      "Purpose"     = "provisioning"
                                  }
}
