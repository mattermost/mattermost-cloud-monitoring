
data "helm_repository" "gitlab" {
  name = "gitlab"
  url  = "https://charts.gitlab.io"
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.deployment_name
}

data "aws_eks_cluster" "cluster" {
  name = var.deployment_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
  load_config_file       = false
  config_path            = "${var.kubeconfig_dir}/kubeconfig"
  version                = "1.10.0" #Locking version because newest breaks the provider
}

provider "helm" {
  install_tiller  = true
  service_account = "terraform-tiller"
  namespace       = "kube-system"
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v${var.tiller_version}"
  kubernetes {
    config_path            = "${var.kubeconfig_dir}/kubeconfig"
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster_auth.token
    load_config_file       = false
  }
  version        = "0.10.4"
  
}


