
# resource "kubernetes_service_account" "tiller" {
#   metadata {
#     name      = "terraform-tiller"
#     namespace = "kube-system"
#   }

#   automount_service_account_token = true
# }

# resource "kubernetes_cluster_role_binding" "tiller" {
#   metadata {
#     name = "terraform-tiller"
#   }

#   role_ref {
#     kind      = "ClusterRole"
#     name      = "cluster-admin"
#     api_group = "rbac.authorization.k8s.io"
#   }

#   subject {
#     kind = "ServiceAccount"
#     name = "terraform-tiller"

#     api_group = ""
#     namespace = "kube-system"
#   }
# }

# provider "helm" {
# #   install_tiller  = true
#   service_account = "${kubernetes_service_account.tiller.metadata.0.name}"
#   namespace       = "${kubernetes_service_account.tiller.metadata.0.namespace}"
#   tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.11.0"

#   kubernetes {
#     config_path = "./kubeconfig_monitoring"
#   }
# }


# resource "helm_release" "example" {
#   name       = "my-redis-release"
#   chart      = "redis"
#   version    = "6.0.1"
#   depends_on = [
#     "aws_eks_cluster.cluster", "kubernetes_cluster_role_binding.tiller"
#   ]
# }

