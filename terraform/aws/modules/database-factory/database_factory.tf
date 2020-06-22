data "aws_caller_identity" "current" {}

resource "kubernetes_deployment" "mattermost_cloud_database_factory" {
  metadata {
    name      = "mattermost-cloud-database-factory"
    namespace = var.mattermost_cloud_namespace

    labels = {
      "app.kubernetes.io/component" = "database-factory"
      "app.kubernetes.io/name"      = "mattermost-cloud-database-factory"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "database-factory"
        "app.kubernetes.io/name"      = "mattermost-cloud-database-factory"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "database-factory"
          "app.kubernetes.io/name"      = "mattermost-cloud-database-factory"
        }
      }

      spec {
        container {
          name  = "mattermost-cloud-database-factory"
          image = var.mattermost_cloud_dbfactory_image
          args  = ["server", "--debug"]

          port {
            name           = "api"
            container_port = 8077
          }

          env {
            name = "AWS_SECRET_ACCESS_KEY"

            value_from {
              secret_key_ref {
                name = "mattermost-cloud-database-factory-secret"
                key  = "AWS_SECRET_ACCESS_KEY"
              }
            }
          }

          env {
            name = "AWS_ACCESS_KEY_ID"

            value_from {
              secret_key_ref {
                name = "mattermost-cloud-database-factory-secret"
                key  = "AWS_ACCESS_KEY_ID"
              }
            }
          }

          env {
            name = "AWS_DEFAULT_REGION"

            value_from {
              secret_key_ref {
                name = "mattermost-cloud-database-factory-secret"
                key  = "AWS_REGION"
              }
            }
          }

          env {
            name = "AWS_REGION"

            value_from {
              secret_key_ref {
                name = "mattermost-cloud-database-factory-secret"
                key  = "AWS_REGION"
              }
            }
          }

          env {
            name = "MattermostAlertsHook"
            value = var.mattermost_alerts_hook
          }

          env {
            name = "MattermostNotificationsHook"
            value = var.mattermost_notifications_hook
          }

          image_pull_policy = "Always"
        }
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_unavailable = "1"
      }
    }

    revision_history_limit = 2
  }

  # Will be added in the future when managed by flux
  #   lifecycle {
  #     ignore_changes = [
  #       metadata,
  #       spec,
  #     ]
  #   }

}

resource "kubernetes_ingress" "mattermost_cloud_database_factory_ingress" {
  metadata {
    name      = "mattermost-cloud-database-factory"
    namespace = var.mattermost_cloud_namespace

    annotations = {
      "kubernetes.io/ingress.class" = "nginx-internal"
    }
  }

  spec {
    rule {
      host = var.mattermost_cloud_dbfactory_ingress

      http {
        path {
          path = "/"

          backend {
            service_name = "mattermost-cloud-database-factory-service"
            service_port = "8077"
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

resource "kubernetes_secret" "mattermost_cloud_database_factory_secret" {
  metadata {
    name      = "mattermost-cloud-database-factory-secret"
    namespace = var.mattermost_cloud_namespace
  }

  data = {
    AWS_ACCESS_KEY_ID     = var.mattermost_cloud_database_factory_secrets_aws_access_key
    AWS_SECRET_ACCESS_KEY = var.mattermost_cloud_database_factory_secrets_aws_secret_key
    AWS_REGION            = var.mattermost_cloud_database_factory_secrets_aws_region
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

resource "kubernetes_service" "mattermost_cloud_database_factory_service" {
  metadata {
    name      = "mattermost-cloud-database-factory-service"
    namespace = var.mattermost_cloud_namespace
  }

  spec {
    port {
      name        = "api"
      port        = 8077
      target_port = "api"
    }

    selector = {
      "app.kubernetes.io/component" = "database-factory"
      "app.kubernetes.io/name"      = "mattermost-cloud-database-factory"
    }

    type = "ClusterIP"
  }

  # Will be added in the future when managed by flux
  #   lifecycle {
  #     ignore_changes = [
  #       metadata,
  #       spec,
  #     ]
  #   }

}
