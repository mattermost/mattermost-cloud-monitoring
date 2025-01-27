###########» Worker Node AutoScaling Group###########
locals {
  service_cidr = data.aws_eks_cluster.cluster.kubernetes_network_config[0].service_ipv4_cidr
  worker-userdata = var.use_al2023 ? base64encode(<<USERDATA
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
}

locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH


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
}

module "managed_node_group" {
  source                 = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/eks-managed-node-groups?ref=v1.8.19"
  vpc_security_group_ids = [aws_security_group.worker-sg.id]
  vpc_id                 = var.vpc_id
  volume_size            = var.node_volume_size
  volume_type            = var.node_volume_type
  image_id               = var.eks_ami_id
  instance_type          = var.instance_type
  arm_image_id           = var.eks_arm_image_id
  arm_instance_type      = var.arm_instance_type
  user_data              = base64encode(local.worker-userdata)
  cluster_name           = aws_eks_cluster.cluster.name
  node_role_arn          = aws_iam_role.worker-role.arn
  subnet_ids             = flatten(var.private_subnet_ids)
  deployment_name        = var.deployment_name
  desired_size           = var.desired_size
  max_size               = var.max_size
  min_size               = var.min_size
  arm_desired_size       = var.arm_desired_size
  arm_max_size           = var.arm_max_size
  arm_min_size           = var.arm_min_size
  node_group_name        = var.node_group_name
  cluster_short_name     = var.cluster_short_name
  spot_desired_size      = var.spot_desired_size
  spot_max_size          = var.spot_max_size
  spot_min_size          = var.spot_min_size
  spot_instance_type     = var.spot_instance_type
  availability_zones     = var.availability_zones
  subnets                = var.map_subnets
  enable_spot_nodes      = var.enable_spot_nodes
  use_al2023             = var.use_al2023
  al2023_ami_id          = var.al2023_ami_id
  al2023_arm_image_id    = var.al2023_arm_image_id
  api_server_endpoint    = aws_eks_cluster.cluster.endpoint
  certificate_authority  = aws_eks_cluster.cluster.certificate_authority[0].data
  service_ipv4_cidr      = local.service_cidr
}
