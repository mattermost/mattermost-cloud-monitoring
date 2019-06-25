resource "kubernetes_secret" "kubernetes-dashboard-certs" {
  metadata {
    name = "kubernetes-dashboard-certs"
    namespace = "kube-system"
    labels {
    "k8s-app" = "kubernetes-dashboard"
    }
  }
  type = "Opaque"
}

resource "kubernetes_service_account" "kubernetes-dashboard-svc-acc" {
  metadata {
    name = "kubernetes-dashboard"
    namespace = "kube-system"
    labels {
      "k8s-app" = "kubernetes-dashboard"
    }
  }
}

resource "kubernetes_role" "kubernetes-dashboard-role" {
  metadata {
    name = "kubernetes-dashboard-minimal"
    namespace = "kube-system"
    labels {
      "k8s-app" = "kubernetes-dashboard"
    }
  }

  rule {
    # Allow Dashboard to create 'kubernetes-dashboard-key-holder' secret.
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["create"]
  }
  rule {
    # Allow Dashboard to create 'kubernetes-dashboard-settings' config map.
    api_groups = [""]
    resources = ["configmaps"]
    verbs = ["create"]
  }
  rule {
    # Allow Dashboard to get, update and delete Dashboard exclusive secrets.
    api_groups = [""]
    resources = ["secrets"]
    resource_names = ["kubernetes-dashboard-key-holder", "kubernetes-dashboard-certs"]
    verbs = ["get", "update", "delete"]
  }
  rule {
    # Allow Dashboard to get and update 'kubernetes-dashboard-settings' config map.
    api_groups = [""]
    resources = ["configmaps"]
    resource_names = ["kubernetes-dashboard-settings"]
    verbs = ["get", "update"]
  }
  rule {
    # Allow Dashboard to get metrics from heapster.
    api_groups = [""]
    resources = ["services"]
    resource_names = ["heapster"]
    verbs = ["proxy"]
  }
  rule {
    # Allow Dashboard to get metrics from heapster.
    api_groups = [""]
    resources = ["services/proxy"]
    resource_names = ["heapster", "http:heapster:", "https:heapster:"]
    verbs = ["get"]
  }
}

resource "kubernetes_role_binding" "kubernetes-dashboard-rolebinding" {
  metadata {
    name = "kubernetes-dashboard-minimal"
    namespace = "kube-system"
    labels {
      "k8s-app" = "kubernetes-dashboard"
    }
  }
  role_ref {
      api_group = "rbac.authorization.k8s.io"
      kind = "Role"
      name = "kubernetes-dashboard-minimal"
  }
  subject {
      kind = "ServiceAccount"
      name = "kubernetes-dashboard"
      namespace = "kube-system"
  }
}

resource "kubernetes_deployment" "kubernetes-dashboard-deployment" {
  metadata {
    name = "kubernetes-dashboard"
    namespace = "kube-system"
    labels {
      "k8s-app" = "kubernetes-dashboard"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        "k8s-app" = "kubernetes-dashboard"
      }
    }

    template {
      metadata {
        labels {
          "k8s-app" = "kubernetes-dashboard"
        }
      }

      spec {
        container {
          image = "k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.1"
          name  = "kubernetes-dashboard"
          port {
            container_port = 8443
            protocol = "TCP"
          }
          args = ["--auto-generate-certificates"]
          volume_mount {
            mount_path = "/certs"
            name       = "kubernetes-dashboard-certs"
          }
          volume_mount {
            mount_path = "/tmp"
            name       = "tmp-volume"
          }
          liveness_probe {
            http_get {
              path = "/"
              port = 843
            }
            initial_delay_seconds = 30
            period_seconds        = 30
          }
        }
        volume {
          name = "kubernetes-dashboard-certs"
          secret {
            secret_name = "kubernetes-dashboard-certs"
          }
        }
        volume {
          name = "tmp-volume"
          empty_dir {}
        }
        service_account_name = "kubernetes-dashboard"
        # not implemented yet
        # tolerations {
        #   key = "node-role.kubernetes.io/master"
        #   effect = "NoSchedule"
        # }
      }
    }
  }
}

resource "kubernetes_service" "kubernetes-dashboard-svc" {
  metadata {
    name      = "kubernetes-dashboard"
    namespace = "kube-system"
    labels {
      "k8s-app" = "kubernetes-dashboard"
    }
  }
  spec {
    selector {
      "k8s-app" = "kubernetes-dashboard"
    }
    port {
      port        = 443
      target_port = 8443
    }
  }
}

resource "kubernetes_service_account" "heapster-svc-acc" {
  metadata {
    name = "heapster"
    namespace = "kube-system"
  }
}

resource "kubernetes_deployment" "heapster-deployment" {
  metadata {
    name = "heapster"
    namespace = "kube-system"
    labels {
      "task" = "monitoring"
      "k8s-app" = "heapster"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        "task" = "monitoring"
        "k8s-app" = "heapster"
      }
    }

    template {
      metadata {
        labels {
          "task" = "monitoring"
          "k8s-app" = "heapster"
        }
      }

      spec {
        container {
          image = "k8s.gcr.io/heapster-amd64:v1.5.4"
          name  = "heapster"
          image_pull_policy = "IfNotPresent"
          command = ["/heapster", "--source=kubernetes:https://kubernetes.default", "--sink=influxdb:http://monitoring-influxdb.kube-system.svc:8086"]
        }
        service_account_name = "heapster"
      }
    }
  }
}

resource "kubernetes_service" "heapster-svc" {
  metadata {
    name      = "heapster"
    namespace = "kube-system"
    labels {
      "task" = "monitoring"
      "kubernetes.io/cluster-service" = "true"
      "kubernetes.io/name" =  "Heapster"
    }
  }
  spec {
    selector {
      "k8s-app" = "heapster"
    }
    port {
      port        = 80
      target_port = 8082
    }
  }
}

resource "kubernetes_role_binding" "heapster-rolebinding" {
  metadata {
    name = "heapster"
    namespace = "kube-system"
  }
  role_ref {
      api_group = "rbac.authorization.k8s.io"
      kind = "ClusterRole"
      name = "system:heapster"
  }
  subject {
      kind = "ServiceAccount"
      name = "heapster"
      namespace = "kube-system"
  }
}

resource "kubernetes_deployment" "monitoring-influxdb-deployment" {
  metadata {
    name = "monitoring-influxdb"
    namespace = "kube-system"
    labels {
      "task" = "monitoring"
      "k8s-app" = "influxdb"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        "task" = "monitoring"
        "k8s-app" = "influxdb"
      }
    }

    template {
      metadata {
        labels {
          "task" = "monitoring"
          "k8s-app" = "influxdb"
        }
      }

      spec {
        container {
          image = "k8s.gcr.io/heapster-influxdb-amd64:v1.5.2"
          name  = "influxdb"
          image_pull_policy = "IfNotPresent"
          volume_mount {
            mount_path = "/data"
            name       = "influxdb-storage"
          }
        }
        volume {
          name = "influxdb-storage"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_service" "monitoring-influxdb-svc" {
  metadata {
    name      = "monitoring-influxdb"
    namespace = "kube-system"
    labels {
      "task" = "monitoring"
      "kubernetes.io/cluster-service" = "true"
      "kubernetes.io/name" =  "monitoring-influxdb"
    }
  }
  spec {
    selector {
      "k8s-app" = "influxdb"
    }
    port {
      port        = 8086
      target_port = 8086
    }
  }
}

resource "kubernetes_service_account" "eks-admin-svc-acc" {
  metadata {
    name = "eks-admin"
    namespace = "kube-system"
  }
}

resource "kubernetes_role_binding" "eks-admin-rolebinding" {
  metadata {
    name = "eks-admin"
    namespace = "kube-system"
  }
  role_ref {
      api_group = "rbac.authorization.k8s.io"
      kind = "ClusterRole"
      name = "cluster-admin"
  }
  subject {
      kind = "ServiceAccount"
      name = "eks-admin"
      namespace = "kube-system"
  }
}
