resource "kubernetes_namespace" "network" {
  metadata {
    name = "network"
  }
}