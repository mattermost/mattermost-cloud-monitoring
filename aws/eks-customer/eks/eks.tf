module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.14.0"

	cluster_name = var.cluster_name
	cluster_version = var.cluster_version

	vpc_id = var.vpc_id

	create_iam_role = true
	# iam_role_additional_policies = {
	# 	AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  #   additional                         = aws_iam_policy.node_additional.arn
	# }

	cluster_endpoint_public_access = var.cluster_endpoint_public_access
	cluster_endpoint_private_access = var.cluster_endpoint_private_access

	cluster_enabled_log_types = var.cluster_enabled_log_types

	# cluster_addons = {
	# 	coredns = {
	# 		version = var.coredns_version
	# 	}

	# 	kube-proxy = {
	# 		version = var.kube_proxy_version
	# 	}

	# 	aws-ebs-csi-driver = {
	# 		version = var.ebs_csi_version
	# 	}

	# 	snapshot-controller = {
	# 		version = var.snapshot_controller_version
	# 	}
	# }


	subnet_ids = data.aws_subnets.private.ids
	cluster_security_group_additional_rules = var.cluster_security_group_additional_rules
	cluster_security_group_tags = var.cluster_security_group_tags

	enable_cluster_creator_admin_permissions = true
  # access_entries = {
  #   # One access entry with a policy associated
  #   provisioner = {
  #     kubernetes_groups = []
  #     principal_arn     = "arn:aws:iam::926412419614:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSAdministratorAccess_d1e9700799a73262"

  #     policy_associations = {
  #       single = {
  #         policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
  #         access_scope = {
  #           namespaces = ["default"]
  #           type       = "namespace"
  #         }
  #       }
  #     }
  #   }
	# }
}

# resource "null_resource" "tag-vpc" {
# 	provisioner "local-exec" {
# 	  command = "aws ec2 create-tags --resources ${var.vpc_id} --tags Key=Available,Value=false"
# 	}

# 	depends_on = [ module.eks ]
# }

resource "time_sleep" "this" {

  create_duration = "5m"

  triggers = {
    cluster_name         = module.eks.cluster_name
    cluster_endpoint     = module.eks.cluster_endpoint
    cluster_version      = module.eks.cluster_version

    cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  }
}
