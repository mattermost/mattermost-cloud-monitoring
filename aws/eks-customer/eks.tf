module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31.6"

  cluster_name    = "${var.cluster_name}-${local.cluster_id}"
  cluster_version = var.cluster_version

  vpc_id = var.vpc_id

  create_iam_role                  = var.create_iam_role
  iam_role_use_name_prefix         = var.iam_role_use_name_prefix
  create_kms_key                   = var.create_kms_key
  attach_cluster_encryption_policy = var.attach_cluster_encryption_policy
  cluster_encryption_config        = var.cluster_encryption_config

  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access

  cluster_enabled_log_types = var.cluster_enabled_log_types


  control_plane_subnet_ids                = data.aws_subnets.private.ids
  subnet_ids                              = concat(data.aws_subnets.private.ids, data.aws_subnets.public.ids)
  create_cluster_security_group           = var.create_cluster_security_group
  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules
  cluster_additional_security_group_ids   = data.aws_security_groups.control-plane.ids
  create_node_security_group              = var.create_node_security_group

  cluster_tags                 = var.cluster_tags
  enable_auto_mode_custom_tags = var.enable_auto_mode_custom_tags

  enable_cluster_creator_admin_permissions = false
  access_entries = {
    # One access entry with a policy associated
    argocd-deployer = {
      kubernetes_groups = []
      principal_arn     = var.argocd_role_arn

      policy_associations = {
        argocd = {
          policy_arn = var.eks_cluster_admin_policy_arn
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
          policy_arn = var.eks_cluster_admin_policy_arn
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
          policy_arn = var.eks_cluster_admin_policy_arn
          access_scope = {
            type = "cluster"
          }
        }
      }
    },
    atlantis = {
      kubernetes_groups = []
      principal_arn     = var.atlantis_user_arn
      policy_associations = {
        atlantis = {
          policy_arn = var.eks_cluster_admin_policy_arn
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

  create_duration = var.wait_for_cluster_timeout

  triggers = {
    cluster_name     = module.eks.cluster_name
    cluster_endpoint = module.eks.cluster_endpoint
    cluster_version  = module.eks.cluster_version

    cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  }
}

resource "null_resource" "tag_vpc" {
  triggers = {
    region = var.region
    vpc_id = var.vpc_id

    cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  }
  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      aws ec2 create-tags --resources ${self.triggers.vpc_id} --tags Key=CloudClusterType,Value=kops --region ${self.triggers.region}
    EOT
  }
}
