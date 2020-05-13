resource "aws_iam_policy" "rds_db_factory" {
  name        = "mattermost-database-factory-rds-policy"
  path        = "/"
  description = "RDS permissions for database factory user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "rds0",
            "Effect": "Allow",
            "Action": [
                "rds:CreateDBCluster",
                "rds:DeleteDBCluster"
            ],
            "Resource": [
                "arn:aws:rds:us-east-1:${data.aws_caller_identity.current.account_id}:cluster:rds-cluster-multitenant-*",
                "arn:aws:rds:us-east-1:${data.aws_caller_identity.current.account_id}:cluster-pg:mattermost-*",
                "arn:aws:rds:us-east-1:${data.aws_caller_identity.current.account_id}:subgrp:mattermost-*"
            ]
        },
        {
            "Sid": "rds2",
            "Effect": "Allow",
            "Action": [
                "rds:DescribeDBSubnetGroups",
                "rds:DescribeDBClusters",
                "rds:AddTagsToResource",
                "rds:DescribeGlobalClusters",
                "rds:CreateDBInstance",
                "rds:DeleteDBInstance",
                "rds:DescribeDBInstances",
                "rds:ListTagsForResource"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "s3_db_factory" {
  name        = "mattermost-database-factory-s3-policy"
  path        = "/"
  description = "S3 permissions for database factory user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets"
            ],
            "Resource": "arn:aws:s3:::*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::terraform-database-factory-state-bucket-${var.environment}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:GetObjectVersionAcl"
            ],
            "Resource": "arn:aws:s3:::terraform-database-factory-state-bucket-${var.environment}/*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "secrets_manager_db_factory" {
  name        = "mattermost-database-factory-secretsmanager-policy"
  path        = "/"
  description = "Secrets Manager permissions for database factory user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "secrets0",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:DescribeSecret",
                "secretsmanager:GetResourcePolicy",
                "secretsmanager:PutSecretValue",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:DeleteSecret"
            ],
            "Resource": "arn:aws:secretsmanager:us-east-1:${data.aws_caller_identity.current.account_id}:secret:rds-cluster-multitenant-*"
        },
        {
            "Sid": "secrets1",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:CreateSecret"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "kms_db_factory" {
  name        = "mattermost-database-factory-kms-policy"
  path        = "/"
  description = "KMS permissions for database factory user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "kms0",
            "Effect": "Allow",
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
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "iam_db_factory" {
  name        = "mattermost-database-factory-iam-policy"
  path        = "/"
  description = "IAM permissions for database factory user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "kms0",
            "Effect": "Allow",
            "Action": [
                "iam:GetRole",
                "iam:PassRole"
            ],
            "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/rds-enhanced-monitoring-mattermost-cloud-${var.environment}-provisioning"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "ec2_db_factory" {
  name        = "mattermost-database-factory-ec2-policy"
  path        = "/"
  description = "EC2 permissions for database factory user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "kms0",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeVpc*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "autoscaling_db_factory" {
  name        = "mattermost-database-factory-autoscaling-policy"
  path        = "/"
  description = "Autoscaling permissions for database factory user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "autoscaling0",
            "Effect": "Allow",
            "Action": [
                "application-autoscaling:RegisterScalableTarget",
                "application-autoscaling:DescribeScalableTargets",
                "application-autoscaling:DeregisterScalableTarget",
                "application-autoscaling:PutScalingPolicy",
                "application-autoscaling:DescribeScalingPolicies",
                "application-autoscaling:DeleteScalingPolicy",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:PutMetricAlarm"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "attach_rds_db_factory" {
  for_each = toset(var.database_factory_users)
  user     = each.value

  policy_arn = aws_iam_policy.rds_db_factory.arn
}

resource "aws_iam_user_policy_attachment" "attach_s3_db_factory" {
  for_each   = toset(var.database_factory_users)
  user       = each.value
  policy_arn = aws_iam_policy.s3_db_factory.arn
}

resource "aws_iam_user_policy_attachment" "attach_secrets_manager_db_factory" {
  for_each   = toset(var.database_factory_users)
  user       = each.value
  policy_arn = aws_iam_policy.secrets_manager_db_factory.arn
}

resource "aws_iam_user_policy_attachment" "attach_kms_db_factory" {
  for_each   = toset(var.database_factory_users)
  user       = each.value
  policy_arn = aws_iam_policy.kms_db_factory.arn
}

resource "aws_iam_user_policy_attachment" "attach_iam_db_factory" {
  for_each   = toset(var.database_factory_users)
  user       = each.value
  policy_arn = aws_iam_policy.iam_db_factory.arn
}

resource "aws_iam_user_policy_attachment" "attach_ec2_db_factory" {
  for_each   = toset(var.database_factory_users)
  user       = each.value
  policy_arn = aws_iam_policy.ec2_db_factory.arn
}

resource "aws_iam_user_policy_attachment" "attach_autoscaling_db_factory" {
  for_each   = toset(var.database_factory_users)
  user       = each.value
  policy_arn = aws_iam_policy.autoscaling_db_factory.arn
}
