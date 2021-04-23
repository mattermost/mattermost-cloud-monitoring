resource "kubernetes_cron_job" "cloud_blackbox_target_discovery_cron" {
  metadata {
    name      = "cloud-blackbox-target-discovery"
    namespace = var.monitoring_namespace
  }
  spec {
    concurrency_policy            = "Forbid"
    failed_jobs_history_limit     = 5
    successful_jobs_history_limit = 2
    schedule                      = var.blackbox_target_discovery_cronjob_schedule
    suspend                       = false

    job_template {
      metadata {}
      spec {
        ttl_seconds_after_finished = 86400
        template {
          metadata {}
          spec {
            service_account_name = kubernetes_service_account.cloud_blackbox_target_discovery_role_sa.metadata.0.name
            container {
              name              = "cloud-blackbox-target-discovery"
              image             = var.cloud_blackbox_target_discovery_image
              image_pull_policy = "IfNotPresent"

              volume_mount {
                mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
                name       = kubernetes_service_account.cloud_blackbox_target_discovery_role_sa.default_secret_name
                read_only  = true
              }

              env {
                name  = "PRIVATE_HOSTED_ZONE_ID"
                value = var.private_hosted_zone_id
              }

              env {
                name  = "PUBLIC_HOSTED_ZONE_ID"
                value = var.public_hosted_zone_id
              }

              env {
                name  = "PROMETHEUS_NAMESPACE"
                value = var.monitoring_namespace
              }

              env {
                name  = "EXCLUDED_TARGETS"
                value = var.excluded_targets
              }

              env {
                name  = "ADDITIONAL_TARGETS"
                value = var.additional_targets
              }

              env {
                name  = "PROMETHEUS_SECRET_NAME"
                value = var.prometheus_secret_name
              }

              env {
                name  = "MATTERMOST_ALERTS_HOOK"
                value = var.mattermost_alerts_hook
              }

              env {
                name  = "BIND_SERVERS"
                value = var.bind_servers
              }
            }
            volume {
              name = kubernetes_service_account.cloud_blackbox_target_discovery_role_sa.default_secret_name
              secret {
                secret_name = kubernetes_service_account.cloud_blackbox_target_discovery_role_sa.default_secret_name
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_role" "cloud_blackbox_target_discovery_role" {
  metadata {
    name      = "cloud-blackbox-target-discovery"
    namespace = var.monitoring_namespace
    labels = {
      app = "cloud-blackbox-target-discovery"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get", "list", "create", "update"]
  }
}

resource "kubernetes_role_binding" "cloud_blackbox_target_discovery_role_binding" {
  metadata {
    name      = "cloud-blackbox-target-discovery"
    namespace = var.monitoring_namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.cloud_blackbox_target_discovery_role.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.cloud_blackbox_target_discovery_role_sa.metadata.0.name
    namespace = var.monitoring_namespace
  }
}

resource "kubernetes_service_account" "cloud_blackbox_target_discovery_role_sa" {
  metadata {
    name      = "cloud-blackbox-target-discovery"
    namespace = var.monitoring_namespace
  }
}
