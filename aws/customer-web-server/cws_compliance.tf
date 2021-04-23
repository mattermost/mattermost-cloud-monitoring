resource "kubernetes_cron_job" "cws_compliance_cron" {
  count = var.deploy_cws_compliance_cronjob ? 1 : 0

  metadata {
    name      = "cws-compliance-lookup"
    namespace = var.cws_name
  }
  spec {
    concurrency_policy            = "Forbid"
    failed_jobs_history_limit     = 1
    successful_jobs_history_limit = 1
    schedule                      = var.cws_compliance_cronjob_schedule
    suspend                       = false

    job_template {
      metadata {}
      spec {
        ttl_seconds_after_finished = 86400
        template {
          metadata {}
          spec {
            container {
              name              = "cws-compliance-lookup"
              image             = var.cws_compliance_image
              image_pull_policy = "IfNotPresent"
              args              = ["compliance", "start", "--compliance-username", "$(CWS_DESCARTES_USER)", "--compliance-password", "$(CWS_DESCARTES_PASS)", "--compliance-url", "$(CWS_DESCARTES_URL)", "--database", "$(DATABASE)"]

              env_from {
                secret_ref {
                  name = "customer-web-server-secret"
                }
              }
            }
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
    kubernetes_namespace.customer_web_server,
    kubernetes_secret.cws_secret
  ]
}
