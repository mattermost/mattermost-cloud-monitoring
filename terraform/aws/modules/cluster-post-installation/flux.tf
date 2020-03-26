resource "null_resource" "flux_crd" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${var.kubeconfig_dir}/kubeconfig apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/flux-helm-release-crd.yaml" 
  }
}

resource "helm_release" "flux" {
  name  = "mattermost-cm-flux"
  chart = "fluxcd/flux"
  namespace  = "flux"
  values = [
    "${file("../../../../../../chart-values/flux_values.yaml")}"
  ]

  set {
    name  = "git.url"
    value = var.git_url
  }

  set {
    name  = "git.path"
    value = var.git_path
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
    kubernetes_namespace.flux,
    null_resource.flux_crd
  ]
}

resource "kubernetes_service" "flux_provisioner_service" {
  metadata {
    name = "fluxcloud"
    namespace = "flux"
  }
  spec {
    selector = {
      name = "fluxcloud"
    }
    port {
      protocol = "TCP"
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
    name = "fluxcloud"
    namespace = "flux"
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        name = "fluxcloud"
      }
    }

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels = {
          name = "fluxcloud"
        }
      }

      spec {
        security_context {
          run_as_user = "999"
        }
        container {
          name = "fluxcloud"
          image = "justinbarrick/fluxcloud:v0.3.9"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = "3032"
          }

          env {
              name = "SLACK_URL"
              value = var.community_hook
          }
          env {
              name = "SLACK_CHANNEL"
              value = var.community_channel
          }
          env {
              name = "SLACK_USERNAME"
              value = "Flux Deployer"
          }
          env {
              name = "SLACK_ICON_EMOJI"
              value = ":heart:"
          }
          env {
              name = "GITHUB_URL"
              value = var.flux_git_url
          }
          env {
              name = "LISTEN_ADDRESS"
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
