###############################################################################
# 1. Fetch the Tigera Operator Manifest Dynamically (only if Calico enabled)
###############################################################################
data "http" "tigera_operator" {
  count = var.is_calico_enabled ? 1 : 0
  url   = "https://raw.githubusercontent.com/projectcalico/calico/${var.calico_operator_version}/manifests/tigera-operator.yaml"
}

locals {
  tigera_operator_docs = var.is_calico_enabled ? tolist([
    for doc in split("\n---\n", data.http.tigera_operator[0].response_body) : yamldecode(doc)
    if trimspace(doc) != ""
  ]) : tolist([])
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
