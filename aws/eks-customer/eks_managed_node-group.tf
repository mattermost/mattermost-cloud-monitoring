module "managed_node_group" {
  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"

	for_each = var.node_groups

	name = each.value.name
  cluster_name = module.eks.cluster_name
	cluster_version = module.eks.cluster_version

	cluster_service_cidr = module.eks.cluster_service_cidr
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
  vpc_security_group_ids            = [module.eks.node_security_group_id]
	subnet_ids                        = data.aws_subnets.private.ids
	
	min_size     = each.value.min_size
  max_size     = each.value.max_size
  desired_size = each.value.desired_size

	tags = {
    Environment = "dev"
    Terraform   = "true"
  }

	depends_on = [ kubectl_manifest.calico_operator_configuration ]
}