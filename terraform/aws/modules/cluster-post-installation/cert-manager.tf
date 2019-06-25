data "helm_repository" "jetstack" {
    name = "jetstack"
    url  = "https://charts.jetstack.io"
}
resource "null_resource" "certmanagercrds" {
  provisioner "local-exec" {
    command = <<LOCAL_EXEC
      kubectl --kubeconfig "${var.kubeconfig_dir}"/kubeconfig apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.8/deploy/manifests/00-crds.yaml
    LOCAL_EXEC
  }
}

resource "helm_release" "certmanager" {
  name       = "mattermost-cm-certmanager"
  namespace  = "cert-manager"
  repository = "${data.helm_repository.jetstack.metadata.0.name}"
  chart      = "jetstack/cert-manager"
  depends_on = [
    "null_resource.certmanagercrds"
    ]
}

resource "null_resource" "clusterissuer" {
  provisioner "local-exec" {
    command = <<LOCAL_EXEC
      kubectl --kubeconfig "${var.kubeconfig_dir}"/kubeconfig create -f "${path.module}/templates/letsencrypt-clusterissuer-prod.yaml"
    LOCAL_EXEC
  }
  depends_on = [
    "helm_release.certmanager"
    ]
}
