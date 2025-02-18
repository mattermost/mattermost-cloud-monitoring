data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  extra_auth_config_provider = var.provider_role_arn == "" ? "" : local.provider_auth_config
  service_cidr               = data.aws_eks_cluster.cluster.kubernetes_network_config[0].service_ipv4_cidr
  config_map_aws_auth        = <<CONFIGMAPAWSAUTH

apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.worker-role.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH

  worker_userdata = var.use_al2023 ? base64encode(<<USERDATA
#!/bin/bash
set -e

echo Configuring nodeadm for AL2023
cat <<EOF > /etc/eks/nodeadm-config.yaml
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${aws_eks_cluster.cluster.name}
    apiServerEndpoint: ${aws_eks_cluster.cluster.endpoint}
    certificateAuthority: ${aws_eks_cluster.cluster.certificate_authority[0].data}
    cidr: ${local.service_cidr}
EOF

/usr/local/bin/nodeadm --config /etc/eks/nodeadm-config.yaml
USERDATA
    ) : base64encode(<<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.cluster.certificate_authority[0].data}' '${aws_eks_cluster.cluster.name}' --kubelet-extra-args "--kube-reserved cpu=250m,memory=1Gi,ephemeral-storage=1Gi --system-reserved cpu=250m,memory=0.2Gi,ephemeral-storage=1Gi --eviction-hard memory.available<0.2Gi,nodefs.available<10%"
USERDATA
  )
  provider_auth_config = <<YAML

  - rolearn: "${var.provider_role_arn}"
    username: admin
    groups:
      - system:masters
  YAML
  kubeconfig           = <<KUBECONFIG

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
}
