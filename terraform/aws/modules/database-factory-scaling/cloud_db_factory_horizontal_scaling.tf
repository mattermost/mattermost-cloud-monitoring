resource "kubernetes_cron_job" "cloud_db_factory_horizontal_scaling_cron" {
  metadata {
    name      = "cloud-db-factory-horizontal-scaling"
    namespace = var.mattermost_cloud_namespace
  }
  spec {
    concurrency_policy            = "Forbid"
    failed_jobs_history_limit     = 5
    successful_jobs_history_limit = 2
    schedule                      = var.horizontal_scaling_cronjob_schedule
    suspend                       = false

    job_template {
      metadata {}
      spec {
        ttl_seconds_after_finished = 86400
        template {
          metadata {}
          spec {
            container {
              name              = "cloud-db-factory-horizontal-scaling"
              image             = var.cloud_db_factory_horizontal_scaling_image
              image_pull_policy = "IfNotPresent"

              env {
                name  = "RDSMultitenantDBClusterNamePrefix"
                value = var.rds_multitenant_dbcluster_name_prefix
              }

              env {
                name  = "RDSMultitenantDBClusterTagPurpose"
                value = var.rds_multitenant_dbcluster_tag_purpose
              }

              env {
                name  = "RDSMultitenantDBClusterTagDatabaseType"
                value = var.rds_multitenant_dbcluster_tag_database_type
              }

              env {
                name  = "RDSMultitenantDBClusterTagInstallationDatabase"
                value = var.rds_multitenant_dbcluster_tag_installation_database
              }

              env {
                name  = "MaxAllowedInstallations"
                value = var.max_allowed_installations
              }

              env {
                name  = "Environment"
                value = var.environment
              }

              env {
                name  = "StateStore"
                value = var.state_store
              }

              env {
                name  = "DBInstanceType"
                value = var.db_instance_type
              }

              env {
                name  = "TerraformApply"
                value = var.terraform_apply
              }

              env {
                name  = "BackupRetentionPeriod"
                value = var.backup_retention_period
              }

              env {
                name  = "DatabaseFactoryEndpoint"
                value = var.database_factory_endpoint
              }

              env {
                name  = "MattermostNotificationsHook"
                value = var.mattermost_notifications_hook
              }

              env {
                name  = "MattermostAlertsHook"
                value = var.mattermost_alerts_hook
              }

              env {
                name = "AWS_SECRET_ACCESS_KEY"

                value_from {
                  secret_key_ref {
                    name = kubernetes_secret.cloud_db_factory_horizontal_scaling_secret.metadata[0].name
                    key  = "AWS_SECRET_ACCESS_KEY"
                  }
                }
              }

              env {
                name = "AWS_ACCESS_KEY_ID"

                value_from {
                  secret_key_ref {
                    name = kubernetes_secret.cloud_db_factory_horizontal_scaling_secret.metadata[0].name
                    key  = "AWS_ACCESS_KEY_ID"
                  }
                }
              }

              env {
                name = "AWS_DEFAULT_REGION"

                value_from {
                  secret_key_ref {
                    name = kubernetes_secret.cloud_db_factory_horizontal_scaling_secret.metadata[0].name
                    key  = "AWS_REGION"
                  }
                }
              }

              env {
                name = "AWS_REGION"

                value_from {
                  secret_key_ref {
                    name = kubernetes_secret.cloud_db_factory_horizontal_scaling_secret.metadata[0].name
                    key  = "AWS_REGION"
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  # Will be added in the future when managed by flux
  #   lifecycle {
  #     ignore_changes = [
  #       metadata,
  #       spec,
  #     ]
  #   }
}

resource "kubernetes_secret" "cloud_db_factory_horizontal_scaling_secret" {
  metadata {
    name      = "cloud-db-factory-horizontal-scaling-secret"
    namespace = var.mattermost_cloud_namespace
  }

  data = {
    AWS_ACCESS_KEY_ID     = var.cloud_db_factory_hs_secrets_aws_access_key
    AWS_SECRET_ACCESS_KEY = var.cloud_db_factory_hs_secrets_aws_secret_key
    AWS_REGION            = var.cloud_db_factory_hs_secrets_aws_region
  }

  type = "Opaque"

  # Will be added in the future when managed by flux
  #   lifecycle {
  #     ignore_changes = [
  #       metadata,
  #       data,
  #       type,
  #     ]
  #   }
}
