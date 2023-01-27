data "aws_caller_identity" "current" {}

resource "kubernetes_config_map" "aws_auth_configmap" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = <<YAML
- rolearn: "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.deployment_name}-worker-role"
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
- rolearn: arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AWSReservedSSO_AWSAdministratorAccess_${var.aws_reserved_sso_id}
  username: system:masters
  groups:
    - eks-console-dashboard-full-access-group
- rolearn: arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/Cloud${title(var.environment)}Admin
  username: system:masters
  groups:
    - eks-console-dashboard-full-access-group
- rolearn: arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ArgoCD-Deployer
  username: argocd-deployer
  groups:
    - system:masters
  YAML
  }
  depends_on = [
    aws_eks_cluster.cluster
  ]
}

resource "kubernetes_cluster_role_binding" "console_access" {
  metadata {
    name = "eks-console-dashboard-full-access-binding"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "eks-console-dashboard-full-access-clusterrole"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "Group"
    name      = "eks-console-dashboard-full-access-group"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role" "console_access" {
  metadata {
    name = "eks-console-dashboard-full-access-clusterrole"
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "namespaces", "pods"]
    verbs      = ["get", "list"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "daemonsets", "statefulsets", "replicasets"]
    verbs      = ["get", "list"]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["jobs"]
    verbs      = ["get", "list"]
  }
}
