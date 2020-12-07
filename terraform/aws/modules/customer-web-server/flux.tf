resource "null_resource" "flux_crd" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${var.kubeconfig_dir}/kubeconfig apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml"
  }
}

resource "kubernetes_namespace" "flux_cws" {
  metadata {
    name = "flux-cws"
  }
}

resource "helm_release" "flux" {
  name       = "mattermost-cm-flux-cws"
  chart      = "flux"
  namespace  = kubernetes_namespace.flux_cws.id
  repository = "https://charts.fluxcd.io"
  values = [
    file("../../../../chart-values/flux_cws_values.yaml")
  ]

  set {
    name  = "git.url"
    value = var.git_url
  }

  set {
    name  = "git.path"
    value = var.git_path_cws
  }

  set {
    name  = "git.user"
    value = var.git_user
  }

  set {
    name  = "git.email"
    value = var.git_email
  }

  set_string {
    name  = "ssh.known_hosts"
    value = var.ssh_known_hosts
  }

  set {
    name  = "prometheus.enabled"
    value = "true"
  }

  set {
    name  = "registry.disableScanning"
    value = "true"
  }

  depends_on = [
    null_resource.flux_crd
  ]
}

resource "kubernetes_service" "flux_provisioner_service" {
  metadata {
    name      = "fluxcloud-cws"
    namespace = kubernetes_namespace.flux_cws.id
  }
  spec {
    selector = {
      name = "fluxcloud-cws"
    }
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 3032
    }
  }
  depends_on = [
    helm_release.flux
  ]
}

resource "kubernetes_deployment" "flux_provisioner_deployment" {
  metadata {
    name      = "fluxcloud-cws"
    namespace = kubernetes_namespace.flux_cws.id
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        name = "fluxcloud-cws"
      }
    }

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels = {
          name = "fluxcloud-cws"
        }
      }

      spec {
        security_context {
          run_as_user = "999"
        }
        container {
          name              = "fluxcloud-cws"
          image             = "ctadeu/fluxcloud:v0.3.9-mattermost"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = "3032"
          }

          env {
            name  = "MATTERMOST_URL"
            value = var.community_hook
          }
          env {
            name  = "EXPORTER_TYPE"
            value = "mattermost"
          }
          env {
            name  = "MATTERMOST_CHANNEL"
            value = var.community_channel
          }
          env {
            name  = "MATTERMOST_USERNAME"
            value = "Flux Deployer Customer Web Server - Portal"
          }
          env {
            name  = "MATTERMOST_ICON_URL"
            value = "https://user-images.githubusercontent.com/27962005/35868977-0d5f85f6-0b2c-11e8-9fa8-8e4eaf35161a.png"
          }
          env {
            name  = "GITHUB_URL"
            value = var.flux_git_url_cws
          }
          env {
            name  = "LISTEN_ADDRESS"
            value = ":3032"
          }
        }
      }
    }
  }
  depends_on = [
    helm_release.flux
  ]
}
