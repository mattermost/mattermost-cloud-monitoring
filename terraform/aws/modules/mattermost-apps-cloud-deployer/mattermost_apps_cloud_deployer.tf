resource "kubernetes_namespace" "mattermost_apps_cloud_deployer" {
  metadata {
    name = var.mattermost_apps_cloud_deployer_namespace
  }
}

resource "kubernetes_cron_job" "mattermost_apps_cloud_deployer_cron" {
  metadata {
    name      = "mattermost-apps-cloud-deployer"
    namespace = var.mattermost_apps_cloud_deployer_namespace
  }
  spec {
    concurrency_policy            = "Forbid"
    failed_jobs_history_limit     = 2
    successful_jobs_history_limit = 2
    schedule                      = var.mattermost_apps_cloud_deployer_cronjob_schedule
    suspend                       = false

    job_template {
      metadata {}
      spec {
        ttl_seconds_after_finished = 86400
        template {
          metadata {}
          spec {
            container {
              name              = "mattermost-apps-cloud-deployer"
              image             = var.mattermost_apps_cloud_deployer_image
              image_pull_policy = "IfNotPresent"

              env {
                name  = "AppsBundleBucketName"
                value = var.apps_bundle_bucket_name
              }

              env {
                name  = "TempDir"
                value = var.temp_dir
              }

              env {
                name  = "TerraformTemplateDir"
                value = var.terraform_template_dir
              }

              env {
                name  = "TerraformStateBucket"
                value = var.terraform_state_bucket
              }

              env {
                name  = "AppsAssumeRole"
                value = var.apps_assumed_role
              }

              env {
                name  = "Environment"
                value = var.environment
              }

              env {
                name  = "StaticBucket"
                value = var.static_bucket
              }

              env {
                name  = "TerraformApply"
                value = var.terraform_apply
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
                name  = "PrivateSubnetIDs"
                value = var.private_subnet_ids
              }

              env {
                name = "AWS_SECRET_ACCESS_KEY"

                value_from {
                  secret_key_ref {
                    name = kubernetes_secret.mattermost_apps_cloud_deployer_secret.metadata[0].name
                    key  = "AWS_SECRET_ACCESS_KEY"
                  }
                }
              }

              env {
                name = "AWS_ACCESS_KEY_ID"

                value_from {
                  secret_key_ref {
                    name = kubernetes_secret.mattermost_apps_cloud_deployer_secret.metadata[0].name
                    key  = "AWS_ACCESS_KEY_ID"
                  }
                }
              }

              env {
                name = "AWS_DEFAULT_REGION"

                value_from {
                  secret_key_ref {
                    name = kubernetes_secret.mattermost_apps_cloud_deployer_secret.metadata[0].name
                    key  = "AWS_REGION"
                  }
                }
              }

              env {
                name = "AWS_REGION"

                value_from {
                  secret_key_ref {
                    name = kubernetes_secret.mattermost_apps_cloud_deployer_secret.metadata[0].name
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

  depends_on = [
    kubernetes_namespace.mattermost_apps_cloud_deployer,
  ]
}

resource "kubernetes_secret" "mattermost_apps_cloud_deployer_secret" {
  metadata {
    name      = "mattermost-apps-cloud-deployer-secret"
    namespace = var.mattermost_apps_cloud_deployer_namespace
  }

  data = {
    AWS_ACCESS_KEY_ID     = aws_iam_access_key.mattermost_apps_cloud_deployer_user.id
    AWS_SECRET_ACCESS_KEY = aws_iam_access_key.mattermost_apps_cloud_deployer_user.secret
    AWS_REGION            = var.mattermost_apps_cloud_deployer_aws_region
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
  depends_on = [
    kubernetes_namespace.mattermost_apps_cloud_deployer,
  ]
}

