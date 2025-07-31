resource "aws_launch_template" "cluster_nodes_eks_launch_template" {
  count       = var.is_calico_enabled ? 0 : 1
  name        = "${var.cluster_short_name}_cluster_launch_template"
  description = "${var.cluster_short_name} cluster nodes launch template"

  vpc_security_group_ids = var.vpc_security_group_ids

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
    }
  }

  image_id      = var.use_al2023 ? var.al2023_ami_id : var.image_id
  instance_type = var.instance_type
  ebs_optimized = var.ebs_optimized

  user_data = var.use_al2023 ? base64encode(<<USERDATA
#!/bin/bash
echo "export AWS_REGION=${data.aws_region.current.name}" >> /etc/environment
source /etc/environment
cat <<EOF > /etc/eks/nodeadm-config.yaml
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${var.cluster_name}
    apiServerEndpoint: |
      ${var.api_server_endpoint}
    certificateAuthority: |
      ${var.certificate_authority}
    cidr: ${var.service_ipv4_cidr}
  containerd:
    config: |
      [plugins."io.containerd.grpc.v1.cri"]
        sandbox_image = "${var.pause_container_image}"
EOF

/usr/local/bin/nodeadm init -c file:///etc/eks/nodeadm-config.yaml
USERDATA
    ) : base64encode(<<USERDATA
#!/bin/bash
/etc/eks/bootstrap.sh --apiserver-endpoint '${var.api_server_endpoint}' --b64-cluster-ca '${var.certificate_authority}' '${var.cluster_name}' --kubelet-extra-args "--kube-reserved cpu=250m,memory=1Gi,ephemeral-storage=1Gi --system-reserved cpu=250m,memory=0.2Gi,ephemeral-storage=1Gi --eviction-hard memory.available<0.2Gi,nodefs.available<10%"
USERDATA
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name              = "${var.cluster_short_name}-cluster-nodes"
      KubernetesCluster = var.cluster_name
      VpcID             = var.vpc_id
    }
  }
}

resource "aws_eks_node_group" "general_nodes_eks_cluster_ng" {
  count           = var.is_calico_enabled ? 0 : 1
  cluster_name    = var.cluster_name
  node_group_name = "${var.node_group_name}-nodes"

  node_role_arn = var.node_role_arn

  subnet_ids = var.subnet_ids

  tags = {
    "Name" : "${var.deployment_name}-worker",
    "kubernetes.io/cluster/${var.deployment_name}" : "owned",
    "k8s.io/cluster-autoscaler/enabled" : "on",
    "k8s.io/cluster-autoscaler/${var.deployment_name}" : "on"
    KubernetesCluster : var.cluster_name
  }

  labels = {
    Name = "${var.node_group_name}_nodes"
  }

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  launch_template {
    name    = aws_launch_template.cluster_nodes_eks_launch_template[0].name
    version = aws_launch_template.cluster_nodes_eks_launch_template[0].latest_version
  }

  lifecycle {
    create_before_destroy = true
  }
}
