
locals {
  custom_tags = {
    Owner = "cloud-team"
  }

  default_tags = merge(var.tags, local.custom_tags)
  aws_managed_policies = [
    data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn,
    data.aws_iam_policy.AmazonVPCReadOnlyAccess.arn,
    data.aws_iam_policy.AmazonRoute53ReadOnlyAccess.arn
  ]

}
