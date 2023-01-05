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
            "Sid": "rds2",
            "Effect": "Allow",
            "Action": [
                "rds:DescribeDBSubnetGroups",
                "rds:DescribeDBClusters",
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
                "s3:GetBucketEncryption",
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
                "s3:GetObject",
                "s3:GetObjectTagging",
                "s3:GetObjectAcl",
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
                "s3:GetBucketEncryption",
                "s3:ListBucketVersions",
                "s3:ListAllMyBuckets",
                "s3:GetBucketTagging",
                "s3:GetBucketPublicAccessBlock",
                "s3:GetObject",
                "s3:GetObjectTagging",
                "s3:GetObjectAcl",
                "s3:GetObjectVersionAcl"
            ],
            "Resource": "arn:aws:s3:::*"
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
                "ec2:Describe*",
                "ec2:GetLaunchTemplateData",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DescribeInstanceHealth",
                "elasticloadbalancing:DescribeLoadBalancers",
                "autoscaling:DescribeTags",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeScalingActivities",
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeLoadBalancers",
                "autoscaling:DetachInstances",
                "autoscaling:DescribeWarmPool",
                "autoscaling:DescribeAutoscalingInstances",
                "autoscaling:DescribeLifecycleHooks",
                "acm:ListCertificates",
                "acm:ListTagsForCertificate",
                "sqs:ListQueues",
                "events:ListRules"
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
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:GetInstanceProfile",
                "iam:ListAttachedRolePolicies"
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
                "iam:ListAttachedUserPolicies",
                "iam:ListAccessKeys"
            ],
            "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/cloud-*"
        },
        {
            "Sid": "iam3",
            "Effect": "Allow",
            "Action": [
                "iam:GetPolicy"
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
                "kms:List*",
                "kms:Get*"
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
