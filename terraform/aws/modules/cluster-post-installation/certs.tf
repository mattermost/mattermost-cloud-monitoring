resource "kubernetes_secret" "grafana-cert" {
  metadata {
    name      = "grafana-server-tls"
    namespace = "monitoring"
    labels = {
      "certmanager.k8s.io/certificate-name" = "grafana-server-tls"
    }
  }

  data = {
    "tls.crt" = var.grafana_tls_crt
    "tls.key" = var.grafana_tls_key
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_secret" "prometheus-cert" {
  metadata {
    name      = "prometheus-server-tls"
    namespace = "monitoring"
    labels = {
      "certmanager.k8s.io/certificate-name" = "prometheus-server-tls"
    }
  }

  data = {
    "tls.crt" = var.prometheus_tls_crt
    "tls.key" = var.prometheus_tls_key
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_secret" "kibana-cert" {
  metadata {
    name      = "kibana-server-tls"
    namespace = "logging"
    labels = {
      "certmanager.k8s.io/certificate-name" = "kibana-server-tls"
    }
  }

  data = {
    "tls.crt" = var.kibana_tls_crt
    "tls.key" = var.kibana_tls_key
  }

  type = "kubernetes.io/tls"
}
