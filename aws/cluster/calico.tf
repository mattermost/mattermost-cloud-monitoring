###############################################################################
# 1. Fetch the Tigera Operator Manifest Dynamically (only if Calico enabled)
###############################################################################
data "http" "tigera_operator" {
  count = var.is_calico_enabled ? 1 : 0
  url   = "https://raw.githubusercontent.com/projectcalico/calico/${var.calico_operator_version}/manifests/tigera-operator.yaml"
}

locals {
  kubeconfig = <<KUBECONFIG

apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.cluster.endpoint}
    certificate-authority-data: ${aws_eks_cluster.cluster.certificate_authority[0].data}
  name: ${aws_eks_cluster.cluster.arn}
contexts:
- context:
    cluster: ${aws_eks_cluster.cluster.arn}
    user: ${aws_eks_cluster.cluster.arn}
  name: ${aws_eks_cluster.cluster.arn}
current-context: ${aws_eks_cluster.cluster.arn}
kind: Config
preferences: {}
users:
- name: ${aws_eks_cluster.cluster.arn}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
        - --region
        - ${data.aws_region.current.name}
        - eks
        - get-token
        - --cluster-name
        - ${aws_eks_cluster.cluster.name}
        - --output
        - json
      command: aws
KUBECONFIG

  # Split the fetched YAML into parts using the document separator.
  tigera_operator_parts = split("\n---\n", data.http.tigera_operator[0].response_body)

  # Decode each part into a map, filtering out any empty parts.
  tigera_operator_docs = [for part in local.tigera_operator_parts : yamldecode(part) if trimspace(part) != ""]
}

resource "local_file" "kubeconfig" {
  content  = local.kubeconfig
  filename = "${path.root}/kubeconfig-${aws_eks_cluster.cluster.name}"

}

resource "aws_secretsmanager_secret" "kubeconfig_secret" {
  name = aws_eks_cluster.cluster.name
}

resource "aws_secretsmanager_secret_version" "kubeconfig_secret_version" {
  secret_id     = aws_secretsmanager_secret.kubeconfig_secret.id
  secret_string = local_file.kubeconfig.content

  depends_on = [local.kubeconfig]
}

resource "null_resource" "delete_aws_node" {
  provisioner "local-exec" {
    command = "KUBECONFIG=${path.root}/kubeconfig-${aws_eks_cluster.cluster.name} kubectl delete daemonset aws-node -n kube-system"
  }

  depends_on = [resource.local_file.kubeconfig]
}

###############################################################################
# 2. Deploy Each Document from the Tigera Operator Manifest as a Resource
###############################################################################
resource "kubernetes_manifest" "calico_operator" {
  for_each = { for idx, doc in local.tigera_operator_docs : idx => doc }
  manifest = each.value

  depends_on = [
    aws_eks_cluster.cluster
  ]
}

###############################################################################
# 3. Deploy the Calico Installation CR (only if Calico enabled)
###############################################################################
resource "kubernetes_manifest" "calico_installation" {
  count = var.is_calico_enabled ? 1 : 0

  manifest = yamldecode(
    file("${path.module}/manifests/calico_installation.yaml")
  )

  depends_on = [
    kubernetes_manifest.calico_operator
  ]
}

###############################################################################
# 4. Deploy the FelixConfiguration CR (only if Calico enabled)
###############################################################################
resource "kubernetes_manifest" "felix_configuration" {
  count = var.is_calico_enabled ? 1 : 0

  manifest = yamldecode(file("${path.module}/manifests/felix_config.yaml"))

  depends_on = [
    kubernetes_manifest.calico_operator
  ]
}
