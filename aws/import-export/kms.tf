data "aws_caller_identity" "current" {}


resource "aws_kms_key" "customer_managed" {
  description = var.kms_key_description
}

resource "aws_kms_key_policy" "customer_managed_policy" {
  key_id = aws_kms_key.customer_managed.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "key-policy",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "${aws_kms_key.customer_managed.arn}"
    },
    {
      "Sid": "Allow access for Key Administrators",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSOrganizationsFullAccess_42ac4a2106c1d64b"
      },
      "Action": [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:TagResource",
        "kms:UntagResource",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion"
      ],
      "Resource": "${aws_kms_key.customer_managed.arn}"
    },
    {
      "Sid": "Allow use of the key by provisioner user",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.other_account_id}:user/${var.other_account_user_name}"
      },
      "Action": "kms:Decrypt",
      "Resource": "${aws_kms_key.customer_managed.arn}"
    },
    {
      "Sid": "Allow use of the key by provisioner role",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.other_account_id}:role/${var.other_account_role_name}"
      },
      "Action": "kms:Decrypt",
      "Resource": "${aws_kms_key.customer_managed.arn}"
    }
  ]
}
EOF
}

resource "aws_kms_alias" "s3_kms_key_alias" {
  name          = "alias/s3-kms-key"
  target_key_id = aws_kms_key.customer_managed.id
}

