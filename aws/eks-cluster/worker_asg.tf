###########» Worker Node AutoScaling Group###########
locals {
  worker-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.cluster.certificate_authority[0].data}' '${var.deployment_name}'
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

module "managed_node_group" {
  source                 = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/eks-managed-node-groups?ref=v1.5.53"
  vpc_security_group_ids = [aws_security_group.worker-sg.id]
  volume_size            = var.node_volume_size
  volume_type            = var.node_volume_type
  image_id               = var.eks_ami_id
  instance_type          = var.instance_type
  user_data              = base64encode(local.worker-userdata)
  cluster_name           = aws_eks_cluster.cluster.name
  node_role_arn          = aws_iam_role.worker-role.arn
  subnet_ids             = flatten(var.private_subnet_ids)
  deployment_name        = var.deployment_name
  desired_size           = var.desired_size
  max_size               = var.max_size
  min_size               = var.min_size
  node_group_name        = var.node_group_name
  cluster_short_name     = var.cluster_short_name
  spot_desired_size      = var.spot_desired_size
  spot_max_size          = var.spot_max_size
  spot_min_size          = var.spot_min_size
  spot_instance_type     = var.spot_instance_type
}
