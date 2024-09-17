module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.14.0"

  cluster_name    = "${var.cluster_name}-${local.cluster_id}"
  cluster_version = var.cluster_version

  vpc_id = var.vpc_id

  create_iam_role                  = true
  iam_role_use_name_prefix         = false
  create_kms_key                   = false
  attach_cluster_encryption_policy = false
  cluster_encryption_config        = {}

  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access

  cluster_enabled_log_types = var.cluster_enabled_log_types


  control_plane_subnet_ids                = data.aws_subnets.private.ids
  subnet_ids                              = concat(data.aws_subnets.private.ids, data.aws_subnets.public.ids)
  create_cluster_security_group           = var.create_cluster_security_group
  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules
  cluster_additional_security_group_ids   = data.aws_security_groups.control-plane.ids
  create_node_security_group              = var.create_node_security_group

  cluster_tags = var.cluster_tags

  enable_cluster_creator_admin_permissions = false
  access_entries = {
    # One access entry with a policy associated
    argocd-deployer = {
      kubernetes_groups = []
      principal_arn     = var.argocd_role_arn

      policy_associations = {
        argocd = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    },
    staff = {
      kubernetes_groups = []
      principal_arn     = var.staff_role_arn
      policy_associations = {
        staff = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    },
    provisioner = {
      kubernetes_groups = []
      principal_arn     = var.provisioner_role_arn
      policy_associations = {
        staff = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
}

resource "aws_ec2_tag" "vpc" {
  resource_id = var.vpc_id

  key   = "CloudClusterType"
  value = "eks"

}

resource "aws_ec2_tag" "subnet" {
  for_each    = toset(data.aws_subnets.public.ids)
  resource_id = each.value

  key   = "kubernetes.io/cluster/${module.eks.cluster_name}"
  value = "shared"
}

resource "time_sleep" "wait_for_cluster" {

  create_duration = "5m"

  triggers = {
    cluster_name     = module.eks.cluster_name
    cluster_endpoint = module.eks.cluster_endpoint
    cluster_version  = module.eks.cluster_version

    cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  }
}
