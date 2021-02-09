resource "kubernetes_cron_job" "cloud_fleet_controller_cron" {
  metadata {
    name      = "fleet-controller-hibernate"
    namespace = var.fleet_controller_namespace
  }
  spec {
    concurrency_policy            = "Forbid"
    failed_jobs_history_limit     = 2
    successful_jobs_history_limit = 2
    schedule                      = var.fleet_controller_cronjob_schedule
    suspend                       = false

    job_template {
      metadata {}
      spec {
        ttl_seconds_after_finished = 86400
        template {
          metadata {}
          spec {
            container {
              name              = "fleet-controller"
              image             = var.fleet_controller_image
              image_pull_policy = "IfNotPresent"
              args              = ["hibernate", "--unlock", "--server=${var.provisioner_server}", "--thanos-url=${var.thanos_server}", "--group=${var.cws_group}", "--dry-run=false"]
              env {
                name  = "FC_PRODUCTION_LOGS"
                value = "true"
              }
              env {
                name  = "FC_MM_WEBHOOK_URL"
                value = var.mm_webhook_url
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
    kubernetes_namespace.fleet_controller
  ]
}


resource "kubernetes_namespace" "fleet_controller" {
  metadata {
    name = "fleet-controller"
  }
}
