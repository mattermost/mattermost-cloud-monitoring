resource "kubernetes_role" "gitlab" {
  metadata {
    name      = "gitlab"
    namespace = "kube-system"
    labels = {
      app = "gitlab"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps", "serviceaccounts"]
    verbs      = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["rbac.authorization.k8s.io"]
    resources  = ["clusterrolebindings"]
    verbs      = ["watch", "list", "get"]
  }
}

resource "kubernetes_role_binding" "gitlab" {
  metadata {
    name      = "gitlab"
    namespace = "kube-system"
    labels = {
      app = "gitlab"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "gitlab"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "gitlab"
  }
  depends_on = [
    kubernetes_role.gitlab,
  ]
}

resource "kubernetes_cluster_role" "gitlab" {
  metadata {
    name = "gitlab"
    labels = {
      app = "gitlab"
    }
  }


  rule {
    api_groups = ["rbac.authorization.k8s.io"]
    resources  = ["clusterrolebindings"]
    verbs      = ["watch", "list", "get"]
  }
}

resource "kubernetes_cluster_role_binding" "gitlab" {
  metadata {
    name = "gitlab"
    labels = {
      app = "gitlab"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "gitlab"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "gitlab"
  }
  depends_on = [
    kubernetes_cluster_role.gitlab,
  ]
}
