resource "aws_iam_policy" "route53" {
  name        = "mattermost-provisioner-route53-policy${local.conditional_dash_region}"
  path        = "/"
  description = "Route53 permissions for provisioner user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "route53",
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets",
                "route53:ListResourceRecordSets",
                "route53:ListHostedZones",
                "route53:ListTagsForResource",
                "route53:GetHostedZone"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "rds" {
  name        = "mattermost-provisioner-rds-policy${local.conditional_dash_region}"
  path        = "/"
  description = "RDS permissions for provisioner user"

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
                "arn:aws:rds:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster:cloud-*",
                "arn:aws:rds:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:subgrp:mattermost-*"
            ]
        },
        {
            "Sid": "rds1",
            "Effect": "Allow",
            "Action": [
                "rds:CreateDBInstance",
                "rds:DeleteDBInstance"
            ],
            "Resource": [
                "arn:aws:rds:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:db:cloud-*",
                "arn:aws:rds:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster:cloud-*"
            ]
        },
        {
            "Sid": "rds2",
            "Effect": "Allow",
            "Action": [
                "rds:DescribeDBSubnetGroups",
                "rds:DescribeDBClusters",
                "rds:AddTagsToResource",
                "rds:DescribeDBClusterEndpoints"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "s3" {
  name        = "mattermost-provisioner-s3-policy${local.conditional_dash_region}"
  path        = "/"
  description = "S3 permissions for provisioner user"

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
                "s3:GetBucketLocation",
                "s3:GetBucketTagging",
                "s3:GetEncryptionConfiguration",
                "s3:ListBucketVersions"
            ],
            "Resource": [
                "arn:aws:s3:::mattermost-kops-state-${var.environment}${local.conditional_dash_region}",
                "arn:aws:s3:::mattermost-cloud-${var.environment}-provisioning-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:GetObjectTagging",
                "s3:GetObjectAcl",
                "s3:DeleteObject",
                "s3:DeleteObjectVersion",
                "s3:GetObjectVersionAcl"
            ],
            "Resource": [
                "arn:aws:s3:::mattermost-kops-state-${var.environment}${local.conditional_dash_region}/*",
                "arn:aws:s3:::mattermost-cloud-${var.environment}-provisioning-*/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation",
                "s3:GetEncryptionConfiguration",
                "s3:ListBucketVersions",
                "s3:GetBucketVersioning",
                "s3:GetBucketTagging",
                "s3:CreateBucket",
                "s3:PutEncryptionConfiguration",
                "s3:PutBucketPublicAccessBlock",
                "s3:GetBucketPublicAccessBlock",
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:PutBucketVersioning",
                "s3:GetObject",
                "s3:GetObjectTagging",
                "s3:GetObjectAcl",
                "s3:DeleteObject",
                "s3:DeleteBucket",
                "s3:DeleteObjectVersion",
                "s3:GetObjectVersionAcl"
            ],
            "Resource": "arn:aws:s3:::cloud-*"
        },
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
                "s3:GetBucketLocation",
                "s3:GetBucketTagging"
            ],
            "Resource": [
                "arn:aws:s3:::${var.awat_bucket_name}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:DeleteObject",
                "s3:GetObjectVersionAcl"
            ],
            "Resource": [
                "arn:aws:s3:::${var.awat_bucket_name}/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "secrets_manager" {
  name        = "mattermost-provisioner-secretsmanager-policy${local.conditional_dash_region}"
  path        = "/"
  description = "Secrets Manager permissions for provisioner user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "secrets0",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:TagResource",
                "secretsmanager:CreateSecret",
                "secretsmanager:DeleteSecret",
                "secretsmanager:GetSecretValue"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "ec2" {
  name        = "mattermost-provisioner-ec2-policy${local.conditional_dash_region}"
  path        = "/"
  description = "EC2, SQS, EventBridge permissions for provisioner user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ec20",
            "Effect": "Allow",
            "Action": [
                "ec2:AttachVolume",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:DescribeInstances",
                "ec2:DeleteTags",
                "ec2:DescribeRegions",
                "ec2:DescribeSnapshots",
                "ec2:DeleteVolume",
                "ec2:DescribeVolumeStatus",
                "ec2:DeleteNetworkInterfacePermission",
                "ec2:StartInstances",
                "ec2:CreateNetworkInterfacePermission",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeVolumes",
                "ec2:DescribeReservedInstances",
                "ec2:DescribeReservedInstancesListings",
                "ec2:DescribeInstanceStatus",
                "ec2:DetachVolume",
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:ModifyVolume",
                "ec2:TerminateInstances",
                "ec2:DescribeTags",
                "ec2:CreateTags",
                "ec2:RunInstances",
                "ec2:StopInstances",
                "ec2:DescribeSecurityGroups",
                "ec2:CreateVolume",
                "ec2:DescribeLaunchTemplates",
                "ec2:DescribeLaunchTemplateVersions",
                "ec2:GetLaunchTemplateData",
                "ec2:ModifyLaunchTemplate",
                "ec2:CreateLaunchTemplate",
                "ec2:CreateLaunchTemplateVersion",
                "ec2:DeleteLaunchTemplate",
                "ec2:CreateLaunchTemplateVersion",
                "ec2:DescribeImages",
                "ec2:DescribeVpcs",
                "ec2:AttachNetworkInterface",
                "ec2:DescribeSubnets",
                "ec2:ImportKeyPair",
                "ec2:DeleteKeyPair",
                "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:CreateLoadBalancer",
                "elasticloadbalancing:CreateTargetGroup",
                "elasticloadbalancing:CreateListener",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DescribeInstanceHealth",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeTargetGroupAttributes",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeListenerAttributes",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:DeleteListener",
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "elasticloadbalancing:CreateLoadBalancerListeners",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:ConfigureHealthCheck",
                "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
                "elasticloadbalancing:AttachLoadBalancerToSubnets",
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:DeleteTargetGroup",
                "elasticloadbalancing:ModifyTargetGroup",
                "elasticloadbalancing:ModifyTargetGroupAttributes",
                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:ModifyListenerAttributes",
                "autoscaling:CreateLaunchConfiguration",
                "autoscaling:DescribeTags",
                "autoscaling:DeleteTags",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:CreateAutoScalingGroup",
                "autoscaling:DeleteLaunchConfiguration",
                "autoscaling:DeleteAutoScalingGroup",
                "autoscaling:DescribeScalingActivities",
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:UpdateAutoScalingGroup",
                "autoscaling:EnableMetricsCollection",
                "autoscaling:AttachLoadBalancers",
                "autoscaling:DetachLoadBalancers",
                "autoscaling:DescribeLoadBalancers",
                "autoscaling:DetachInstances",
                "autoscaling:SuspendProcesses",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "autoscaling:CreateOrUpdateTags",
                "autoscaling:DescribeWarmPool",
                "autoscaling:DescribeAutoscalingInstances",
                "autoscaling:DescribeLifecycleHooks",
                "autoscaling:CompleteLifecycleAction",
                "autoscaling:SetInstanceProtection",
                "autoscaling:PutLifecycleHook",
                "autoscaling:DeleteLifecycleHook",
                "acm:ListCertificates",
                "acm:ListTagsForCertificate",
                "sqs:ListQueues",
                "sqs:CreateQueue",
                "sqs:TagQueue",
                "sqs:GetQueueAttributes",
                "sqs:ListQueueTags",
                "sqs:DeleteQueue",
                "events:ListRules",
                "events:TagResource",
                "events:PutRule",
                "events:DescribeRule",
                "events:ListTagsForResource",
                "events:DeleteRule",
                "events:PutTargets",
                "events:ListTargetsByRule",
                "events:RemoveTargets"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "vpc" {
  name        = "mattermost-provisioner-vpc-policy${local.conditional_dash_region}"
  path        = "/"
  description = "VPC permissions for provisioner user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "vpc0",
            "Effect": "Allow",
            "Action": [
                "ec2:DeleteTags",
                "ec2:CreateTags",
                "ec2:CreateSubnet",
                "ec2:CreateSecurityGroup",
                "ec2:DeleteSecurityGroup",
                "ec2:Describe*",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:RevokeSecurityGroupIngress"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "iam" {
  name        = "mattermost-provisioner-iam-policy${local.conditional_dash_region}"
  path        = "/"
  description = "IAM permissions for provisioner user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "iam0",
            "Effect": "Allow",
            "Action": [
                "iam:GetRole",
                "iam:GetInstanceProfile",
                "iam:ListRoles",
                "iam:ListInstanceProfiles",
                "iam:ListRolePolicies",
                "iam:ListOpenIDConnectProviders",
                "iam:ListAccountAliases",
                "iam:GetOpenIDConnectProvider"
            ],
            "Resource": "*"
        },
        {
            "Sid": "iam1",
            "Effect": "Allow",
            "Action": [
                "iam:ListInstanceProfilesForRole",
                "iam:CreateRole",
                "iam:GetRole",
                "iam:DeleteRole",
                "iam:PutRolePolicy",
                "iam:GetRolePolicy",
                "iam:DeleteRolePolicy",
                "iam:CreateInstanceProfile",
                "iam:GetInstanceProfile",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:DeleteInstanceProfile",
                "iam:AddRoleToInstanceProfile",
                "iam:PassRole",
                "iam:AttachRolePolicy",
                "iam:DetachRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:TagRole",
                "iam:TagInstanceProfile"
            ],
            "Resource": [
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/masters.*",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/nodes.*",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/masters.*",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/nodes.*"
            ]
        },
        {
            "Sid": "iam2",
            "Effect": "Allow",
            "Action": [
                "iam:GetUser",
                "iam:CreateUser",
                "iam:ListAttachedUserPolicies",
                "iam:ListAccessKeys",
                "iam:DeleteUser",
                "iam:AttachUserPolicy",
                "iam:DetachUserPolicy",
                "iam:CreateAccessKey",
                "iam:DeleteAccessKey"
            ],
            "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/cloud-*"
        },
        {
            "Sid": "iam3",
            "Effect": "Allow",
            "Action": [
                "iam:GetPolicy",
                "iam:CreatePolicy",
                "iam:DeletePolicy"
            ],
            "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/cloud-*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "kms" {
  name        = "mattermost-provisioner-kms-policy${local.conditional_dash_region}"
  path        = "/"
  description = "KMS permissions for provisioner user"

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

resource "aws_iam_policy" "tag" {
  name        = "mattermost-provisioner-tag-policy${local.conditional_dash_region}"
  path        = "/"
  description = "Resource Group Tagging permissions for provisioner user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "tag0",
            "Effect": "Allow",
            "Action": [
                "tag:GetResources",
                "tag:GetTagKeys",
                "tag:GetTagValues"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "kms_awat" {
  count       = var.awat_cross_account_enabled ? 1 : 0
  name        = "mattermost-provisioner-kms-awat-policy${local.conditional_dash_region}"
  path        = "/"
  description = "KMS permissions for provisioner user for AWAT bucket"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": "${var.awat_s3_kms_key_arn}"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "attach_tag" {
  for_each   = toset(var.provisioner_users)
  user       = each.value
  policy_arn = aws_iam_policy.tag.arn

  depends_on = [
    aws_iam_user.provisioner_users
  ]
}

resource "aws_iam_user_policy_attachment" "attach_route53" {
  for_each   = toset(var.provisioner_users)
  user       = each.value
  policy_arn = aws_iam_policy.route53.arn

  depends_on = [
    aws_iam_user.provisioner_users
  ]
}

resource "aws_iam_user_policy_attachment" "attach_rds" {
  for_each   = toset(var.provisioner_users)
  user       = each.value
  policy_arn = aws_iam_policy.rds.arn

  depends_on = [
    aws_iam_user.provisioner_users
  ]
}

resource "aws_iam_user_policy_attachment" "attach_s3" {
  for_each   = toset(var.provisioner_users)
  user       = each.value
  policy_arn = aws_iam_policy.s3.arn

  depends_on = [
    aws_iam_user.provisioner_users
  ]
}

resource "aws_iam_user_policy_attachment" "attach_secrets_manager" {
  for_each   = toset(var.provisioner_users)
  user       = each.value
  policy_arn = aws_iam_policy.secrets_manager.arn

  depends_on = [
    aws_iam_user.provisioner_users
  ]
}

resource "aws_iam_user_policy_attachment" "attach_ec2" {
  for_each   = toset(var.provisioner_users)
  user       = each.value
  policy_arn = aws_iam_policy.ec2.arn

  depends_on = [
    aws_iam_user.provisioner_users
  ]
}

resource "aws_iam_user_policy_attachment" "attach_vpc" {
  for_each   = toset(var.provisioner_users)
  user       = each.value
  policy_arn = aws_iam_policy.vpc.arn

  depends_on = [
    aws_iam_user.provisioner_users
  ]
}

resource "aws_iam_user_policy_attachment" "attach_iam" {
  for_each   = toset(var.provisioner_users)
  user       = each.value
  policy_arn = aws_iam_policy.iam.arn

  depends_on = [
    aws_iam_user.provisioner_users
  ]
}

resource "aws_iam_user_policy_attachment" "attach_kms" {
  for_each   = toset(var.provisioner_users)
  user       = each.value
  policy_arn = aws_iam_policy.kms.arn

  depends_on = [
    aws_iam_user.provisioner_users
  ]
}

resource "aws_iam_user_policy_attachment" "attach_kms_awat" {
  for_each   = toset(var.awat_cross_account_enabled ? var.provisioner_users : [])
  user       = each.value
  policy_arn = aws_iam_policy.kms_awat[0].arn

  depends_on = [
    aws_iam_user.provisioner_users
  ]
}
