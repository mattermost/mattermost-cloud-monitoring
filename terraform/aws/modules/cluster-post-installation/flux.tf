resource "null_resource" "flux_crd" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${var.kubeconfig_dir}/kubeconfig apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/flux-helm-release-crd.yaml" 
  }
}

resource "helm_release" "flux" {
  name  = "mattermost-cm-flux"
  chart = "fluxcd/flux"
  namespace  = "flux"

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
