module "managed_node_group" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "20.20.0"

  for_each = { for k, v in var.node_groups : k => v }


  name                            = "${each.key}-${module.eks.cluster_name}"
  cluster_name                    = module.eks.cluster_name
  cluster_version                 = module.eks.cluster_version
  use_name_prefix                 = var.use_name_prefix
  launch_template_use_name_prefix = var.launch_template_use_name_prefix
  iam_role_use_name_prefix        = var.iam_role_use_name_prefix

  enable_bootstrap_user_data = true
  ami_id                     = each.value.ami_id
  instance_types             = each.value.instance_types

  iam_role_additional_policies = {
    cloudProvisioningNode = var.cloud_provisioning_node_policy_arn
    cloudProvisioningEC2  = var.cloud_provisioning_ec2_policy_arn
  }

  cluster_service_cidr              = module.eks.cluster_service_cidr
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
  vpc_security_group_ids            = strcontains(each.key, "calls") ? data.aws_security_groups.calls.ids : data.aws_security_groups.nodes.ids
  subnet_ids                        = strcontains(each.key, "monitoring") ? data.aws_subnets.private-a.ids : data.aws_subnets.private.ids

  min_size     = each.value.min_size
  max_size     = each.value.max_size
  desired_size = each.value.desired_size

  taints = each.value.taints
  labels = each.value.labels

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }

  depends_on = [module.eks, time_sleep.wait_for_cluster]
}
