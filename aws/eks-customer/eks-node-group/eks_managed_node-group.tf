module "managed_node_group" {
  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"

	for_each = var.node_groups

	name = each.value.name
  cluster_name = var.cluster_name
	cluster_version = var.cluster_version

	cluster_service_cidr = var.cluster_service_cidr
  cluster_primary_security_group_id = var.cluster_primary_security_group_id
  vpc_security_group_ids            = [var.node_security_group_id]
	subnet_ids                        = var.subnet_ids
	
	min_size     = each.value.min_size
  max_size     = each.value.max_size
  desired_size = each.value.desired_size

	tags = {
    Environment = "dev"
    Terraform   = "true"
  }

	# depends_on = [ kubectl_manifest.calico_operator_configuration ]
}