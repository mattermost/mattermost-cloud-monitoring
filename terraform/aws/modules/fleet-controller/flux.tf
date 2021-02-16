resource "null_resource" "flux_crd" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml"
  }
}

resource "kubernetes_namespace" "flux_fleet_controller" {
  metadata {
    name = "flux-fleet-controller"
  }
}

resource "helm_release" "flux" {
  name       = "mattermost-cm-flux-fleet-controller"
  chart      = "flux"
  namespace  = kubernetes_namespace.flux_fleet_controller.id
  repository = "https://charts.fluxcd.io"
  values = [
    file("../../../../chart-values/flux_fleet_controller_values.yaml")
  ]

  set {
    name  = "git.url"
    value = var.git_url
  }

  set {
    name  = "git.path"
    value = var.git_path_fleet_controller
  }

  set {
    name  = "git.user"
    value = var.git_user
  }

  set {
    name  = "git.email"
    value = var.git_email
  }

  set {
    name  = "ssh.known_hosts"
    value = var.ssh_known_hosts
    type  = "string"
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

resource "kubernetes_service" "flux_fleet_controller_service" {
  metadata {
    name      = "fluxcloud-fleet-controller"
    namespace = kubernetes_namespace.flux_fleet_controller.id
  }
  spec {
    selector = {
      name = "fluxcloud-fleet-controller"
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

resource "kubernetes_deployment" "flux_fleet_controller_deployment" {
  metadata {
    name      = "fluxcloud-fleet-controller"
    namespace = kubernetes_namespace.flux_fleet_controller.id
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        name = "fluxcloud-fleet-controller"
      }
    }

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels = {
          name = "fluxcloud-fleet-controller"
        }
      }

      spec {
        security_context {
          run_as_user = "999"
        }
        container {
          name              = "fluxcloud-fleet-controller"
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
            value = "Flux Deployer Fleet Controller"
          }
          env {
            name  = "MATTERMOST_ICON_URL"
            value = "https://user-images.githubusercontent.com/27962005/35868977-0d5f85f6-0b2c-11e8-9fa8-8e4eaf35161a.png"
          }
          env {
            name  = "GITHUB_URL"
            value = var.flux_git_url_fleet_controller
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
