locals {
    kubeconfig = <<KUBECONFIG

apiVersion: v1
clusters:
- cluster:
    server: ${module.eks.cluster_endpoint}
    certificate-authority-data: ${module.eks.cluster_certificate_authority_data}
  name: ${module.eks.cluster_arn}
contexts:
- context:
    cluster: ${module.eks.cluster_arn}
    user: ${module.eks.cluster_arn}
  name: ${module.eks.cluster_arn}
current-context: ${module.eks.cluster_arn}
kind: Config
preferences: {}
users:
- name: ${module.eks.cluster_arn}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
        - --region
        - ${var.region}
        - eks
        - get-token
        - --cluster-name
        - ${module.eks.cluster_name}
        - --output
        - json
      command: aws
KUBECONFIG
}

resource "local_file" "kubeconfig" {
    content  = local.kubeconfig
    filename = "${path.root}/kubeconfig"

    depends_on = [module.eks]
}

resource "aws_secretsmanager_secret" "kubeconfig_secret" {
  name = module.eks.cluster_name
}

resource "aws_secretsmanager_secret_version" "kubeconfig_secret_version" {
  secret_id     = aws_secretsmanager_secret.kubeconfig_secret.id
  secret_string = local_file.kubeconfig.content
  
  depends_on = [ local.kubeconfig ]
}
