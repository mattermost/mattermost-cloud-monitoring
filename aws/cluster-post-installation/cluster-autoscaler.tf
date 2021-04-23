resource "kubernetes_secret" "cluster-autoscaler" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
  }
}

resource "kubernetes_service_account" "cluster-autoscaler" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
      k8s-app   = "cluster-autoscaler"
    }
  }

  secret {
    name = kubernetes_secret.cluster-autoscaler.metadata[0].name
  }
  depends_on = [
    kubernetes_secret.cluster-autoscaler
  ]
}

resource "kubernetes_cluster_role" "cluster-autoscaler" {
  metadata {
    name = "cluster-autoscaler"
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
      k8s-app   = "cluster-autoscaler"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["events", "endpoints"]
    verbs      = ["create", "patch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/eviction"]
    verbs      = ["create"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/status"]
    verbs      = ["update"]
  }
  rule {
    api_groups     = [""]
    resources      = ["endpoints"]
    resource_names = ["cluster-autoscaler"]
    verbs          = ["get", "update"]
  }
  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["watch", "list", "get", "update"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods", "services", "replicationcontrollers", "persistentvolumeclaims", "persistentvolumes"]
    verbs      = ["watch", "list", "get"]
  }
  rule {
    api_groups = ["extensions"]
    resources  = ["replicasets", "daemonsets"]
    verbs      = ["watch", "list", "get"]
  }
  rule {
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
    verbs      = ["watch", "list"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["statefulsets", "replicasets", "daemonsets"]
    verbs      = ["watch", "list", "get"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs"]
    verbs      = ["watch", "list", "get"]
  }
  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses", "csinodes"]
    verbs      = ["watch", "list", "get"]
  }
  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["create"]
  }
  rule {
    api_groups     = ["coordination.k8s.io"]
    resources      = ["leases"]
    resource_names = ["cluster-autoscaler"]
    verbs          = ["get", "update"]
  }

  depends_on = [
    kubernetes_service_account.cluster-autoscaler
  ]
}

resource "kubernetes_cluster_role_binding" "cluster-autoscaler" {
  metadata {
    name = "cluster-autoscaler"
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
      k8s-app   = "cluster-autoscaler"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-autoscaler"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "cluster-autoscaler"
    namespace = "kube-system"
  }
  depends_on = [
    kubernetes_cluster_role.cluster-autoscaler,
    kubernetes_service_account.cluster-autoscaler
  ]
}

resource "kubernetes_role" "cluster-autoscaler" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
      k8s-app   = "cluster-autoscaler"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["create"]
  }
  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["cluster-autoscaler-status"]
    verbs          = ["delete", "get", "update"]
  }
}

resource "kubernetes_role_binding" "cluster-autoscaler" {

  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io"
      k8s-app   = "cluster-autoscaler"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "cluster-autoscaler"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "cluster-autoscaler"
    namespace = "kube-system"
  }

  depends_on = [kubernetes_role.cluster-autoscaler]
}

resource "kubernetes_deployment" "cluster-autoscaler" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
    labels = {
      app     = "cluster-autoscaler"
      purpose = "autoscaler"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "cluster-autoscaler"
      }
    }
    template {
      metadata {
        labels = {
          app = "cluster-autoscaler"
        }
      }
      spec {
        service_account_name            = "cluster-autoscaler"
        automount_service_account_token = true
        container {
          name  = "cluster-autoscaler"
          image = "k8s.gcr.io/autoscaling/cluster-autoscaler:v1.17.4"
          resources {
            limits {
              cpu    = "100m"
              memory = "400Mi"
            }
            requests {
              cpu    = "10m"
              memory = "400Mi"
            }
          }
          command = ["./cluster-autoscaler", "--v=2", "--stderrthreshold=error", "--cloud-provider=aws", "--skip-nodes-with-local-storage=false", "--skip-nodes-with-system-pods=false", "--scale-down-delay-after-add=5m", "--scale-down-delay-after-delete=5m", "--node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/${var.deployment_name}"]
          env {
            name  = "AWS_REGION"
            value = var.region
          }
          volume_mount {
            mount_path = "/etc/ssl/certs/ca-bundle.crt"
            name       = "ssl-certs"
            read_only  = true
          }
          image_pull_policy = "IfNotPresent"
        }
        dns_config {
          option {
            name  = "ndots"
            value = "1"
          }
        }
        volume {
          name = "ssl-certs"
          host_path {
            path = "/etc/ssl/certs/ca-bundle.crt"
          }
        }
      }
    }
  }
}
