locals {
  policies_by_name = {
    for policy in concat(values(aws_iam_policy.bifrost), values(aws_iam_policy.velero)) :
    policy.name => policy
  }
}

module "irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.44.0"

  for_each = { for k, v in var.utilities : k => v if v.enable_irsa }

  role_name = "${each.value.name}-${var.cluster_name}"

  role_policy_arns = {
    # policy = data.aws_iam_policy.policies[each.key].arn
    policy = local.policies_by_name["${each.value.name}-${var.cluster_name}"].arn
  }

  oidc_providers = {
    one = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${each.value.name}:${each.value.service_account}"]
    }
  }
}