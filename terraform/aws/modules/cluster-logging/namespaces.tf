resource "kubernetes_namespace" "logging" {
  metadata {
    name = "logging"
  }
}

