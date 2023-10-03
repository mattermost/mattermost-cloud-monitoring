data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_kms_grant" "byok" {
  for_each = var.custom_vpc_kms_keys

  name              = format("%s-%s-byok", var.name, var.custom_vpc_kms_keys[each.key])
  key_id            = var.custom_vpc_kms_keys[each.key]
  grantee_principal = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
  operations        = ["Encrypt", "Decrypt", "ReEncryptFrom", "ReEncryptTo", "GenerateDataKey", "GenerateDataKeyWithoutPlaintext", "DescribeKey", "CreateGrant"]
}
