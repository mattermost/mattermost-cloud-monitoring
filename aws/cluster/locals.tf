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
  containerd:
    config: |
      [plugins."io.containerd.grpc.v1.cri"]
        sandbox_image = "${var.pause_container_image}"
EOF

/usr/local/bin/nodeadm init -c file:///etc/eks/nodeadm-config.yaml

# Fix sandbox image
sed -i 's|sandbox_image = .*|sandbox_image = "${var.pause_container_image}"|' /etc/containerd/config.toml

# Remove any existing containerd config.d directory
[ -d /etc/containerd/config.d ] && rm -rf /etc/containerd/config.d

# Restart containerd to apply config
systemctl restart containerd

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
}
