resource "kubernetes_cluster_role" "atlantis" {
  metadata {
    name = "atlantis"
    labels = {
      app = "atlantis"
    }
  }


  rule {
    api_groups = [""]
    resources = [
      "secrets",
      "configmaps",
      "namespaces",
      "serviceaccounts",
      "services",
      "deployments"
    ]
    verbs = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["rbac.authorization.k8s.io"]
    resources = [
      "roles",
      "clusterroles",
      "clusterrolebindings",
      "rolebindings",
    ]
    verbs = ["watch", "list", "get"]
  }
}

resource "kubernetes_cluster_role_binding" "atlantis" {
  metadata {
    name = "atlantis"
    labels = {
      app = "atlantis"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "atlantis"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "atlantis"
    namespace = "atlantis"
  }
  depends_on = [
    kubernetes_cluster_role.atlantis,
  ]
}
