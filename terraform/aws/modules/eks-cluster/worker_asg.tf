###########» Worker Node AutoScaling Group###########
locals {
  worker-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.cluster.certificate_authority.0.data}' '${var.deployment_name}'
USERDATA
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

resource "aws_launch_template" "cluster_nodes_eks_launch_template" {
  name        = "cnc_cluster_launch_template"
  description = "CnC cluster nodes launch template"

  vpc_security_group_ids = [aws_security_group.worker-sg.id]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 20
      volume_type = "gp2"
    }
  }

  image_id      = var.eks_ami_id
  instance_type = var.instance_type

  user_data = base64encode(local.worker-userdata)

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "cnc-cluster-nodes"
    }
  }
}

resource "aws_eks_node_group" "general_nodes_eks_cluster_ng" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "general-nodes"

  node_role_arn = aws_iam_role.worker-role.arn

  subnet_ids = flatten(var.private_subnet_ids)

  tags = {
    "Name" : "${var.deployment_name}-worker",
    "kubernetes.io/cluster/${var.deployment_name}" : "owned",
    "k8s.io/cluster-autoscaler/enabled" : "on",
    "k8s.io/cluster-autoscaler/${var.deployment_name}" : "on"
  }

  labels = {
    Name = "general_nodes"
  }

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

  launch_template {
    name    = aws_launch_template.cluster_nodes_eks_launch_template.name
    version = aws_launch_template.cluster_nodes_eks_launch_template.latest_version
  }

  lifecycle {
    create_before_destroy = true
  }
}
