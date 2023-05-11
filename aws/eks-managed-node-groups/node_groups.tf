resource "aws_launch_template" "cluster_nodes_eks_launch_template" {
  for_each = var.node_group

  name        = "${var.cluster_short_name}_cluster_launch_template_${each.key}"
  description = "${var.cluster_short_name} cluster nodes launch template"

  vpc_security_group_ids = var.vpc_security_group_ids

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
    }
  }

  image_id      = var.image_id
  instance_type = each.value.instance_type
  ebs_optimized = var.ebs_optimized

  user_data = var.user_data

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name              = "${var.cluster_short_name}-cluster-nodes-${each.key}"
      KubernetesCluster = var.cluster_name
      VpcID             = var.vpc_id
    }
  }
}

resource "aws_eks_node_group" "general_nodes_eks_cluster_ng" {
  for_each = var.node_group

  cluster_name    = var.cluster_name
  node_group_name = "${each.key}-nodes"

  node_role_arn = var.node_role_arn

  subnet_ids = var.subnet_ids

  tags = {
    "Name" : "${var.deployment_name}-worker-${each.key}",
    "kubernetes.io/cluster/${var.deployment_name}" : "owned",
    "k8s.io/cluster-autoscaler/enabled" : "on",
    "k8s.io/cluster-autoscaler/${var.deployment_name}" : "on"
    KubernetesCluster : var.cluster_name

  }

  labels = {
    Name = "${each.key}_nodes"
  }

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  launch_template {
    name    = aws_launch_template.cluster_nodes_eks_launch_template[each.key]["name"]
    version = aws_launch_template.cluster_nodes_eks_launch_template[each.key]["latest_version"]
  }

  dynamic "taint" {
    for_each = each.value.enable_taint == true ? [for i in each.value.taints : {
      key    = i.key
      value  = i.value
      effect = i.effect
    }] : []
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
