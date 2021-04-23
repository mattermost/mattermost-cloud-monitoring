module "database-factory-scaling" {
  source                                 = "github.com/mattermost/mattermost-terraform-modules.git//aws/database-factory-scaling?ref=v1.0.0"
  rds_multitenant_dbinstance_name_prefix = var.rds_multitenant_dbinstance_name_prefix
  environment                            = var.environment
  db_factory_horizontal_scaling_users    = var.db_factory_horizontal_scaling_users
  db_factory_vertical_scaling_users      = var.db_factory_vertical_scaling_users
}
