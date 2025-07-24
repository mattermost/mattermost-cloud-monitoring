module "managed_node_group" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "20.37.1"

  for_each = { for k, v in var.node_groups : k => v }


  name                     = "${each.key}-${module.eks.cluster_name}"
  cluster_name             = module.eks.cluster_name
  cluster_version          = module.eks.cluster_version
  use_name_prefix          = var.use_name_prefix
  iam_role_use_name_prefix = var.iam_role_use_name_prefix
  create_launch_template   = var.create_launch_template
  launch_template_id       = aws_launch_template.node[each.key].id
  launch_template_name     = aws_launch_template.node[each.key].name
  launch_template_version  = aws_launch_template.node[each.key].latest_version
  ami_id                   = each.value.ami_id

  iam_role_additional_policies = {
    cloudNode = aws_iam_policy.node.arn
  }

  cluster_service_cidr = module.eks.cluster_service_cidr
  subnet_ids           = (each.value.public_subnet == false) ? (strcontains(each.key, "monitoring") ? data.aws_subnets.private-a.ids : data.aws_subnets.private.ids) : data.aws_subnets.public.ids

  min_size     = each.value.min_size
  max_size     = each.value.max_size
  desired_size = each.value.desired_size

  update_config = var.update_config

  taints = each.value.taints
  labels = each.value.labels

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

resource "null_resource" "node_group_annotate" {
  for_each = {
    for k, v in var.node_groups :
    k => v
    if v.annotations != null && length(keys(v.annotations)) > 0
  }

  triggers = {
    annotations = jsonencode(each.value.annotations)
  }

  provisioner "local-exec" {
    command = <<EOT
      KUBECONFIG=${path.root}/kubeconfig-${module.eks.cluster_name} kubectl annotate nodes -l eks.amazonaws.com/nodegroup=${split(":", module.managed_node_group[each.key].node_group_id)[1]} \
      ${join(" ", [for key, value in each.value.annotations : "${key}=${value}"])}
    EOT
  }

  depends_on = [module.managed_node_group]
}
