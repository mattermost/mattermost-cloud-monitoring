locals {
    kubeconfig = <<KUBECONFIG

apiVersion: v1
clusters:
- cluster:
    server: ${var.cluster_endpoint}
    certificate-authority-data: ${var.cluster_certificate_authority_data}
  name: ${var.cluster_arn}
contexts:
- context:
    cluster: ${var.cluster_arn}
    user: ${var.cluster_arn}
  name: ${var.cluster_arn}
current-context: ${var.cluster_arn}
kind: Config
preferences: {}
users:
- name: ${var.cluster_arn}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
        - --region
        - ${var.region}
        - eks
        - get-token
        - --cluster-name
        - ${var.cluster_name}
        - --output
        - json
      command: aws
KUBECONFIG
}

resource "local_file" "kubeconfig" {
    content  = local.kubeconfig
    filename = "${path.module}/kubeconfig"

    # depends_on = [module.eks]
}