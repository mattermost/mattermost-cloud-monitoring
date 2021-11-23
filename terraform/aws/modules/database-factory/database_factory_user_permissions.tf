data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

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
                "rds:DeleteDBCluster",
                "rds:ModifyDBCluster",
                "rds:CreateDBClusterParameterGroup",
                "rds:ModifyDBClusterParameterGroup",
                "rds:DescribeDBClusterParameterGroups",
                "rds:DescribeDBClusterParameters",
                "rds:CreateDBParameterGroup",
                "rds:ModifyDBParameterGroup",
                "rds:DescribeDBParameterGroups",
                "rds:DescribeDBParameters",
                "rds:DeleteDBClusterParameterGroup",
                "rds:DeleteDBParameterGroup",
                "rds:ModifyDBInstance",
                "rds:ResetDBParameterGroup"
            ],
            "Resource": [
                "arn:aws:rds:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster:rds-cluster-multitenant-*",
                "arn:aws:rds:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster-pg:rds-cluster-multitenant-*",
                "arn:aws:rds:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:pg:rds-cluster-multitenant-*",
                "arn:aws:rds:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster-pg:mattermost-*",
                "arn:aws:rds:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:subgrp:mattermost-*",
                "arn:aws:rds:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:db:rds-db-instance-multitenant-*"
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
            "Resource": "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:rds-cluster-multitenant-*"
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
        },
        {
            "Sid": "iam0",
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": "*"
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
                "cloudwatch:PutMetricAlarm",
                "cloudwatch:ListTagsForResource",
                "cloudwatch:DeleteAlarms"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "sns_db_factory" {
  name        = "mattermost-database-factory-sns-policy"
  path        = "/"
  description = "SNS permissions for database factory user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "sns0",
            "Effect": "Allow",
            "Action": [
                "sns:ListTopics"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "lambda_and_logs_db_factory" {
  name        = "mattermost-database-factory-lambda-logs-policy"
  path        = "/"
  description = "Lambda and Cloudwatch logs permissions for database factory user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "lambda0",
            "Effect": "Allow",
            "Action": [
                "lambda:ListFunctions",
                "lambda:ListEventSourceMappings",
                "lambda:GetAccountSettings",
                "lambda:TagResource",
                "lambda:InvokeFunction",
                "lambda:GetLayerVersion",
                "lambda:GetFunction",
                "lambda:UpdateFunctionConfiguration",
                "lambda:GetFunctionConfiguration",
                "lambda:AddLayerVersionPermission",
                "lambda:GetLayerVersionPolicy",
                "lambda:RemoveLayerVersionPermission",
                "lambda:UntagResource",
                "lambda:GetFunctionCodeSigningConfig",
                "lambda:UpdateFunctionCode",
                "lambda:ListFunctionEventInvokeConfigs",
                "lambda:AddPermission",
                "lambda:GetFunctionConcurrency",
                "lambda:ListTags",
                "lambda:GetFunctionEventInvokeConfig",
                "lambda:GetAlias",
                "lambda:RemovePermission",
                "lambda:GetPolicy",
                "logs:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "db-factory-role" {
  name = "k8s-${var.environment}-db-factory-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
       "Principal": {
        "AWS": [ "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.deployment_name}-worker-role" ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "db-factory-role-attach_sns" {
  role       = aws_iam_role.db-factory-role.name
  policy_arn = aws_iam_policy.sns_db_factory.arn
}

resource "aws_iam_role_policy_attachment" "db-factory-role-attach_rds" {
  role       = aws_iam_role.db-factory-role.name
  policy_arn = aws_iam_policy.rds_db_factory.arn
}

resource "aws_iam_role_policy_attachment" "db-factory-role-attach_s3" {
  role       = aws_iam_role.db-factory-role.name
  policy_arn = aws_iam_policy.s3_db_factory.arn
}

resource "aws_iam_role_policy_attachment" "db-factory-role-attach_secrets_manager" {
  role       = aws_iam_role.db-factory-role.name
  policy_arn = aws_iam_policy.secrets_manager_db_factory.arn
}

resource "aws_iam_role_policy_attachment" "db-factory-role-attach_kms" {
  role       = aws_iam_role.db-factory-role.name
  policy_arn = aws_iam_policy.kms_db_factory.arn
}

resource "aws_iam_role_policy_attachment" "db-factory-role-attach_iam" {
  role       = aws_iam_role.db-factory-role.name
  policy_arn = aws_iam_policy.iam_db_factory.arn
}

resource "aws_iam_role_policy_attachment" "db-factory-role-attach_ec2" {
  role       = aws_iam_role.db-factory-role.name
  policy_arn = aws_iam_policy.ec2_db_factory.arn
}

resource "aws_iam_role_policy_attachment" "db-factory-role-attach_autoscaling" {
  role       = aws_iam_role.db-factory-role.name
  policy_arn = aws_iam_policy.autoscaling_db_factory.arn
}

resource "aws_iam_role_policy_attachment" "db-factory-role-attach-lambda-and-logs" {
  role       = aws_iam_role.db-factory-role.name
  policy_arn = aws_iam_policy.lambda_and_logs_db_factory.arn
}
