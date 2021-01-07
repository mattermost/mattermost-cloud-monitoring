###########» Worker Node AutoScaling Group###########
locals {
  worker-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.cluster.certificate_authority.0.data}' '${var.deployment_name}' --kubelet-extra-args "--kube-reserved cpu=250m,memory=1Gi,ephemeral-storage=1Gi --system-reserved cpu=250m,memory=0.2Gi,ephemeral-storage=1Gi --eviction-hard memory.available<0.2Gi,nodefs.available<10%"
USERDATA
}

resource "aws_launch_configuration" "worker-lc" {
  iam_instance_profile        = aws_iam_instance_profile.worker-instance-profile.name
  image_id                    = var.eks_ami_id
  instance_type               = var.instance_type
  name_prefix                 = var.deployment_name
  security_groups             = [aws_security_group.worker-sg.id]
  user_data_base64            = base64encode(local.worker-userdata)
  associate_public_ip_address = false
  key_name                    = var.key_name

  root_block_device {
    volume_size = var.volume_size
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "worker-asg" {
  desired_capacity     = var.desired_capacity
  launch_configuration = aws_launch_configuration.worker-lc.id
  max_size             = var.max_size
  min_size             = var.min_size
  name                 = "${var.deployment_name}-worker-asg"
  vpc_zone_identifier  = flatten(var.private_subnet_ids)
  termination_policies = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = "${var.deployment_name}-worker"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.deployment_name}"
    value               = "owned"
    propagate_at_launch = true
  }
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
