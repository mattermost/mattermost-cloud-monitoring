resource "aws_launch_template" "cluster_nodes_eks_arm_launch_template" {
  name        = "${var.cluster_short_name}_cluster_arm_launch_template"
  description = "${var.cluster_short_name} cluster arm nodes launch template"

  vpc_security_group_ids = var.vpc_security_group_ids

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
    }
  }

  # Support for AL2 and AL2023 images dynamically
  image_id      = var.use_al2023 ? var.al2023_arm_image_id : var.arm_image_id
  instance_type = var.arm_instance_type
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
  kubelet:
    config:
      maxPods: ${lookup(var.instance_type_max_pods_map, var.arm_instance_type, 17)}
EOF

/usr/local/bin/nodeadm init -c file:///etc/eks/nodeadm-config.yaml
USERDATA
    ) : base64encode(<<USERDATA
#!/bin/bash
/etc/eks/bootstrap.sh --apiserver-endpoint '${var.api_server_endpoint}' --b64-cluster-ca '${var.certificate_authority}' '${var.cluster_name}' \
  --kubelet-extra-args "--max-pods=${lookup(var.instance_type_max_pods_map, var.arm_instance_type, 17)} --kube-reserved cpu=250m,memory=1Gi,ephemeral-storage=1Gi --system-reserved cpu=250m,memory=0.2Gi,ephemeral-storage=1Gi --eviction-hard memory.available<0.2Gi,nodefs.available<10%"
USERDATA
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name              = "${var.cluster_short_name}-arm-cluster-nodes"
      KubernetesCluster = var.cluster_name
      VpcID             = var.vpc_id
    }
  }
}

resource "aws_launch_template" "calico_cluster_nodes_eks_arm_launch_template" {
  name        = "${var.cluster_short_name}_calico_cluster_arm_launch_template"
  description = "${var.cluster_short_name} cluster arm nodes launch template"

  vpc_security_group_ids = var.vpc_security_group_ids

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
    }
  }

  # Support for AL2 and AL2023 images dynamically
  image_id      = var.use_al2023 ? var.al2023_arm_image_id : var.arm_image_id
  instance_type = var.arm_instance_type
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
  kubelet:
    config:
      maxPods: ${var.calico_max_pods}
EOF

/usr/local/bin/nodeadm init -c file:///etc/eks/nodeadm-config.yaml
USERDATA
    ) : base64encode(<<USERDATA
#!/bin/bash
/etc/eks/bootstrap.sh --apiserver-endpoint '${var.api_server_endpoint}' --b64-cluster-ca '${var.certificate_authority}' '${var.cluster_name}' \
  --kubelet-extra-args "--max-pods=${var.calico_max_pods} --kube-reserved cpu=250m,memory=1Gi,ephemeral-storage=1Gi --system-reserved cpu=250m,memory=0.2Gi,ephemeral-storage=1Gi --eviction-hard memory.available<0.2Gi,nodefs.available<10%"
USERDATA
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name              = "${var.cluster_short_name}-arm-cluster-nodes"
      KubernetesCluster = var.cluster_name
      VpcID             = var.vpc_id
    }
  }
}

resource "aws_eks_node_group" "general_arm_nodes_eks_cluster_ng" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.node_group_name}-arm-nodes"

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
    Name = "${var.node_group_name}_arm_nodes"
  }

  scaling_config {
    desired_size = var.arm_desired_size
    max_size     = var.arm_max_size
    min_size     = var.arm_min_size
  }

  launch_template {
    name    = aws_launch_template.cluster_nodes_eks_arm_launch_template.name
    version = aws_launch_template.cluster_nodes_eks_arm_launch_template.latest_version
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eks_node_group" "calico_arm_nodes" {
  count           = var.is_calico_enabled ? 1 : 0
  cluster_name    = var.cluster_name
  node_group_name = "${var.node_group_name}-calico-arm-nodes"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.calico_desired_size
    min_size     = var.calico_min_size
    max_size     = var.calico_max_size
  }

  labels = {
    "calico" = "true"
  }

  taint {
    key    = "calico"
    value  = "only"
    effect = "NO_SCHEDULE"
  }

  launch_template {
    name    = aws_launch_template.calico_cluster_nodes_eks_arm_launch_template.name
    version = aws_launch_template.calico_cluster_nodes_eks_arm_launch_template.latest_version
  }

  lifecycle {
    create_before_destroy = true
  }
}
