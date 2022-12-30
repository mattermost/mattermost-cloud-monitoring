resource "aws_launch_template" "cluster_spot_nodes_eks_launch_template" {
  name        = "${var.cluster_short_name}_spot_cluster_launch_template"
  description = "${var.cluster_short_name} spot cluster nodes launch template"

  vpc_security_group_ids = var.vpc_security_group_ids

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
    }
  }

  image_id      = var.image_id
  instance_type = var.spot_instance_type
  ebs_optimized = var.ebs_optimized

  user_data = var.user_data

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name              = "${var.cluster_short_name}-spot-cluster-nodes"
      KubernetesCluster = var.cluster_name
    }
  }
}

resource "aws_eks_node_group" "spot_nodes_eks_cluster_ng" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.node_group_name}-spot-nodes"

  node_role_arn = var.node_role_arn

  subnet_ids    = var.subnet_ids
  capacity_type = "SPOT"

  tags = {
    "Name" : "${var.deployment_name}-spot-worker",
    "kubernetes.io/cluster/${var.deployment_name}" : "owned",
    "k8s.io/cluster-autoscaler/enabled" : "on",
    "k8s.io/cluster-autoscaler/${var.deployment_name}" : "on"
    KubernetesCluster : var.cluster_name
  }

  labels = {
    Name = "${var.node_group_name}_spot_nodes"
  }

  scaling_config {
    desired_size = var.spot_desired_size
    max_size     = var.spot_max_size
    min_size     = var.spot_min_size
  }

  launch_template {
    name    = aws_launch_template.cluster_spot_nodes_eks_launch_template.name
    version = aws_launch_template.cluster_spot_nodes_eks_launch_template.latest_version
  }

  lifecycle {
    create_before_destroy = true
  }
}
