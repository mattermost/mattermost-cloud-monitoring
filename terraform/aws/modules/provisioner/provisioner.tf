resource "kubernetes_namespace" "mattermost_cloud" {
  metadata {
    name = var.mattermost-cloud-namespace
  }

  depends_on = [
    aws_db_instance.provisioner
  ]
}

resource "kubernetes_deployment" "mattermost_cloud_main" {
  metadata {
    name      = "mattermost-cloud"
    namespace = var.mattermost-cloud-namespace

    labels = {
      "app.kubernetes.io/component" = "provisioner"
      "app.kubernetes.io/name"      = "mattermost-cloud"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "provisioner"
        "app.kubernetes.io/name"      = "mattermost-cloud"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "provisioner"
          "app.kubernetes.io/name"      = "mattermost-cloud"
        }
      }

      spec {

        volume {
          name = "mattermost-cloud-ssh-volume"

          secret {
            secret_name = "mattermost-cloud-ssh-secret"
          }
        }

        volume {
          name = "mattermost-cloud-tmp-volume"
        }

        volume {
          name = "mattermost-cloud-helm-volume"
        }

        volume {
          name = "mattermost-cloud-helm3-config-volume"
        }

        volume {
          name = "mattermost-cloud-helm3-cache-volume"
        }

        init_container {
          name  = "init-database"
          image = var.mattermost_cloud_image
          args  = ["schema", "migrate", "--database", "$(DATABASE)"]

          env {
            name = "DATABASE"

            value_from {
              secret_key_ref {
                name = "mattermost-cloud-secret"
                key  = "DATABASE"
              }
            }
          }

          image_pull_policy = "Always"
        }

        container {
          name  = "mattermost-cloud"
          image = var.mattermost_cloud_image
          args  = ["server", "--debug", "--state-store", "mattermost-kops-state-${var.environment}${local.conditional_dash_region}", "--keep-filestore-data=$(KEEP_FILESTORE_DATA)", "--keep-database-data=$(KEEP_DATABASE_DATA)", "--database", "$(DATABASE)"]

          port {
            name           = "api"
            container_port = 8075
          }

          env {
            name = "AWS_SECRET_ACCESS_KEY"

            value_from {
              secret_key_ref {
                name = "mattermost-cloud-secret"
                key  = "AWS_SECRET_ACCESS_KEY"
              }
            }
          }

          env {
            name = "AWS_ACCESS_KEY_ID"

            value_from {
              secret_key_ref {
                name = "mattermost-cloud-secret"
                key  = "AWS_ACCESS_KEY_ID"
              }
            }
          }

          env {
            name = "AWS_DEFAULT_REGION"

            value_from {
              secret_key_ref {
                name = "mattermost-cloud-secret"
                key  = "AWS_REGION"
              }
            }
          }

          env {
            name = "AWS_REGION"

            value_from {
              secret_key_ref {
                name = "mattermost-cloud-secret"
                key  = "AWS_REGION"
              }
            }
          }

          env {
            name = "DATABASE"

            value_from {
              secret_key_ref {
                name = "mattermost-cloud-secret"
                key  = "DATABASE"
              }
            }
          }

          env {
            name = "KEEP_DATABASE_DATA"

            value_from {
              secret_key_ref {
                name = "mattermost-cloud-secret"
                key  = "KEEP_DATABASE_DATA"
              }
            }
          }

          env {
            name = "KEEP_FILESTORE_DATA"

            value_from {
              secret_key_ref {
                name = "mattermost-cloud-secret"
                key  = "KEEP_FILESTORE_DATA"
              }
            }
          }

          volume_mount {
            name       = "mattermost-cloud-ssh-volume"
            mount_path = "/.ssh"
          }

          volume_mount {
            name       = "mattermost-cloud-tmp-volume"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "mattermost-cloud-helm-volume"
            mount_path = "/.helm"
          }

          volume_mount {
            name       = "mattermost-cloud-helm3-config-volume"
            mount_path = "/.config"
          }

          volume_mount {
            name       = "mattermost-cloud-helm3-cache-volume"
            mount_path = "/.cache"
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

  lifecycle {
    ignore_changes = [
      metadata,
      spec,
    ]
  }

  depends_on = [
    aws_db_instance.provisioner,
    kubernetes_secret.mattermost_cloud_secret,
    kubernetes_secret.mattermost_cloud_ssh_secret,
    kubernetes_namespace.mattermost_cloud
  ]
}

resource "kubernetes_deployment" "mattermost_cloud_installations" {
  metadata {
    name      = "mattermost-cloud-installations"
    namespace = var.mattermost-cloud-namespace

    labels = {
      "app.kubernetes.io/component" = "provisioner"
      "app.kubernetes.io/name"      = "mattermost-cloud"
      "app.kubernetes.io/extra"     = "mattermost-cloud-installations"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "provisioner"
        "app.kubernetes.io/name"      = "mattermost-cloud"
        "app.kubernetes.io/extra"     = "mattermost-cloud-installations"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "provisioner"
          "app.kubernetes.io/name"      = "mattermost-cloud"
          "app.kubernetes.io/extra"     = "mattermost-cloud-installations"
        }
      }

      spec {

        volume {
          name = "mattermost-cloud-ssh-volume"

          secret {
            secret_name = "mattermost-cloud-ssh-secret"
          }
        }

        volume {
          name = "mattermost-cloud-tmp-volume"
        }

        init_container {
          name  = "init-database"
          image = var.mattermost_cloud_image
          args  = ["schema", "migrate", "--database", "$(DATABASE)"]

          env {
            name = "DATABASE"

            value_from {
              secret_key_ref {
                name = "mattermost-cloud-secret"
                key  = "DATABASE"
              }
            }
          }

          image_pull_policy = "Always"
        }

        container {
          name  = "mattermost-cloud-installations"
          image = var.mattermost_cloud_image
          args  = ["server", "--debug", "--cluster-supervisor=false", "--state-store", "mattermost-kops-state-${var.environment}${local.conditional_dash_region}", "--keep-filestore-data=$(KEEP_FILESTORE_DATA)", "--keep-database-data=$(KEEP_DATABASE_DATA)", "--database", "$(DATABASE)"]

          port {
            name           = "api"
            container_port = 8075
          }

          env {
            name = "AWS_SECRET_ACCESS_KEY"

            value_from {
              secret_key_ref {
                name = "mattermost-cloud-secret"
                key  = "AWS_SECRET_ACCESS_KEY"
              }
            }
          }

          env {
            name = "AWS_ACCESS_KEY_ID"

            value_from {
              secret_key_ref {
                name = "mattermost-cloud-secret"
                key  = "AWS_ACCESS_KEY_ID"
              }
            }
          }

          env {
            name = "AWS_DEFAULT_REGION"

            value_from {
              secret_key_ref {
                name = "mattermost-cloud-secret"
                key  = "AWS_REGION"
              }
            }
          }

          env {
            name = "AWS_REGION"

            value_from {
              secret_key_ref {
                name = "mattermost-cloud-secret"
                key  = "AWS_REGION"
              }
            }
          }

          env {
            name = "DATABASE"

            value_from {
              secret_key_ref {
                name = "mattermost-cloud-secret"
                key  = "DATABASE"
              }
            }
          }

          env {
            name = "KEEP_DATABASE_DATA"

            value_from {
              secret_key_ref {
                name = "mattermost-cloud-secret"
                key  = "KEEP_DATABASE_DATA"
              }
            }
          }

          env {
            name = "KEEP_FILESTORE_DATA"

            value_from {
              secret_key_ref {
                name = "mattermost-cloud-secret"
                key  = "KEEP_FILESTORE_DATA"
              }
            }
          }

          volume_mount {
            name       = "mattermost-cloud-ssh-volume"
            mount_path = "/.ssh"
          }

          volume_mount {
            name       = "mattermost-cloud-tmp-volume"
            mount_path = "/tmp"
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

  lifecycle {
    ignore_changes = [
      metadata,
      spec,
    ]
  }

  depends_on = [
    aws_db_instance.provisioner,
    kubernetes_secret.mattermost_cloud_secret,
    kubernetes_secret.mattermost_cloud_ssh_secret,
    kubernetes_namespace.mattermost_cloud
  ]
}

resource "kubernetes_ingress" "mattermost_cloud_ingress" {
  metadata {
    name      = "mattermost-cloud"
    namespace = var.mattermost-cloud-namespace

    annotations = {
      "kubernetes.io/ingress.class"                        = "nginx-controller"
      "nginx.ingress.kubernetes.io/whitelist-source-range" = var.whitelist_source_range
    }
  }

  spec {
    rule {
      host = var.mattermost_cloud_ingress

      http {
        path {
          path = "/"

          backend {
            service_name = "mattermost-cloud-service"
            service_port = "8075"
          }
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      metadata,
      spec,
    ]
  }

  depends_on = [
    aws_db_instance.provisioner,
    kubernetes_namespace.mattermost_cloud
  ]
}

resource "kubernetes_secret" "mattermost_cloud_secret" {
  metadata {
    name      = "mattermost-cloud-secret"
    namespace = var.mattermost-cloud-namespace
  }

  data = {
    AWS_ACCESS_KEY_ID     = aws_iam_access_key.provisioner_user.id
    AWS_SECRET_ACCESS_KEY = aws_iam_access_key.provisioner_user.secret
    AWS_REGION            = var.mattermost_cloud_secrets_aws_region
    DATABASE              = "postgres://${var.db_username}:${var.db_password}@${aws_db_instance.provisioner.endpoint}/${var.db_name}"
    KEEP_DATABASE_DATA    = var.mattermost_cloud_secrets_keep_database_data
    KEEP_FILESTORE_DATA   = var.mattermost_cloud_secrets_keep_filestore_data
  }

  type = "Opaque"

  lifecycle {
    ignore_changes = [
      metadata,
      data,
      type,
    ]
  }

  depends_on = [
    aws_db_instance.provisioner,
    kubernetes_namespace.mattermost_cloud
  ]
}

resource "kubernetes_secret" "mattermost_cloud_ssh_secret" {
  metadata {
    name      = "mattermost-cloud-ssh-secret"
    namespace = var.mattermost-cloud-namespace
  }

  data = {
    id_rsa       = var.mattermost_cloud_secret_ssh_private
    "id_rsa.pub" = var.mattermost_cloud_secret_ssh_public
  }

  type = "Opaque"

  lifecycle {
    ignore_changes = [
      metadata,
      data,
      type,
    ]
  }

  depends_on = [
    aws_db_instance.provisioner,
    kubernetes_namespace.mattermost_cloud
  ]
}

resource "kubernetes_service" "mattermost_cloud_service" {
  metadata {
    name      = "mattermost-cloud-service"
    namespace = var.mattermost-cloud-namespace
  }

  spec {
    port {
      name        = "api"
      port        = 8075
      target_port = "api"
    }

    selector = {
      "app.kubernetes.io/component" = "provisioner"
      "app.kubernetes.io/name"      = "mattermost-cloud"
    }

    type = "ClusterIP"
  }

  lifecycle {
    ignore_changes = [
      metadata,
      spec,
    ]
  }

  depends_on = [
    aws_db_instance.provisioner,
    kubernetes_namespace.mattermost_cloud
  ]
}
