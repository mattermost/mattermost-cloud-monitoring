resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "network" {
  metadata {
    name = "network"
  }
}

resource "kubernetes_namespace" "flux" {
  metadata {
    name = "flux"
  }
}
