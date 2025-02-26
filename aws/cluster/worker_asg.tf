module "managed_node_group" {
  source                 = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/eks-managed-node-groups?ref=v1.8.45"
  vpc_security_group_ids = [aws_security_group.worker-sg.id]
  volume_size            = var.node_volume_size
  volume_type            = var.node_volume_type

  # Dynamically assign AMIs for AMD64 and ARM64
  image_id     = var.use_al2023 ? var.al2023_ami_id : var.eks_ami_id
  arm_image_id = var.use_al2023 ? var.al2023_arm_image_id : var.eks_arm_image_id

  ebs_optimized     = var.ebs_optimized
  instance_type     = var.instance_type
  arm_instance_type = var.arm_instance_type
  user_data         = local.worker_userdata

  cluster_name          = aws_eks_cluster.cluster.name
  node_role_arn         = aws_iam_role.worker-role.arn
  subnet_ids            = flatten(var.private_subnet_ids)
  deployment_name       = var.deployment_name
  desired_size          = var.desired_size
  max_size              = var.max_size
  min_size              = var.min_size
  node_group_name       = var.node_group_name
  cluster_short_name    = var.cluster_short_name
  spot_desired_size     = var.spot_desired_size
  spot_max_size         = var.spot_max_size
  spot_min_size         = var.spot_min_size
  spot_instance_type    = var.spot_instance_type
  availability_zones    = var.availability_zones
  subnets               = var.map_subnets
  enable_spot_nodes     = var.enable_spot_nodes
  vpc_id                = var.vpc_id
  arm_desired_size      = var.arm_desired_size
  arm_max_size          = var.arm_max_size
  arm_min_size          = var.arm_min_size
  use_al2023            = var.use_al2023
  al2023_ami_id         = var.al2023_ami_id
  al2023_arm_image_id   = var.al2023_arm_image_id
  api_server_endpoint   = aws_eks_cluster.cluster.endpoint
  certificate_authority = aws_eks_cluster.cluster.certificate_authority[0].data
  service_ipv4_cidr     = local.service_cidr
  is_calico_enabled     = var.is_calico_enabled
  calico_min_size       = var.calico_min_size
  calico_desired_size   = var.calico_desired_size
  calico_max_size       = var.calico_max_size
}
