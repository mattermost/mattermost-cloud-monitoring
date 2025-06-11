
resource "aws_iam_role" "private_role" {
  count = var.create_private_role ? 1 : 0

  name = "mattermost-cloud-private-${var.environment}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.github_runners_iam_role_arn
        }
        Action = [
          "sts:TagSession",
          "sts:AssumeRole"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "private" {
  count = var.create_private_role ? 1 : 0

  name        = "mattermost-cloud-private-${var.environment}-policy"
  description = "A policy attached to private IAM role"
  path        = "/"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LambdaPolicyAllResources",
            "Effect": "Allow",
            "Action": [
                "lambda:ListCodeSigningConfigs",
                "lambda:ListEventSourceMappings",
                "lambda:ListVersionsByFunction",
                "lambda:ListFunctionsByCodeSigningConfig",
                "lambda:ListTags",
                "lambda:GetPolicy"
            ],
            "Resource": "*"
        },
        {
            "Sid": "LambdaPolicySpecificResource",
            "Effect": "Allow",
            "Action": [
                "lambda:GetFunction",
                "lambda:GetFunctionConfiguration",
                "lambda:GetFunctionCodeSigningConfig",
                "lambda:GetFunctionEventInvokeConfig",
                "lambda:GetCodeSigningConfig"
            ],
            "Resource": [
                "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:bind-server-network-attachment"
            ]
        },
        {
            "Sid": "AllOtherServicesPolicy",
            "Effect": "Allow",
            "Action": [
              "autoscaling:DescribeAutoScalingGroups",
              "autoscaling:DescribeLifecycleHooks",
              "autoscaling:DescribeInstanceRefreshes",
              "autoscaling:UpdateAutoScalingGroup",
              "autoscaling:PutLifecycleHook",
              "autoscaling:StartInstanceRefresh",
              "ec2:AssociateAddress",
              "ec2:AttachVolume",
              "ec2:AuthorizeSecurityGroupIngress",
              "ec2:CopyImage",
              "ec2:CreateImage",
              "ec2:CreateKeypair",
              "ec2:CreateLaunchTemplateVersion",
              "ec2:CreateSecurityGroup",
              "ec2:CreateSnapshot",
              "ec2:CreateTags",
              "ec2:CreateVolume",
              "ec2:DeleteKeyPair",
              "ec2:DeleteSecurityGroup",
              "ec2:DeleteSnapshot",
              "ec2:DeleteVolume",
              "ec2:DeregisterImage",
              "ec2:DescribeAddresses",
              "ec2:DescribeAddressesAttribute",
              "ec2:DescribeImageAttribute",
              "ec2:DescribeImages",
              "ec2:DescribeInstanceStatus",
              "ec2:DescribeInstances",
              "ec2:DescribeInstanceTypes",
              "ec2:DescribeInstanceAttribute",
              "ec2:DescribeInstanceCreditSpecifications",
              "ec2:DescribeKeyPairs",
              "ec2:DescribeLaunchTemplateVersions",
              "ec2:DescribeLaunchTemplates",
              "ec2:DescribeNetworkInterfaces",
              "ec2:DescribeRegions",
              "ec2:DescribeSecurityGroups",
              "ec2:DescribeSecurityGroupRules",
              "ec2:DescribeSnapshots",
              "ec2:DescribeSubnets",
              "ec2:DescribeTags",
              "ec2:DescribeVolumes",
              "ec2:DescribeVpcAttribute",
              "ec2:DescribeVpcs",
              "ec2:DetachVolume",
              "ec2:DisassociateAddress",
              "ec2:GetPasswordData",
              "ec2:ModifyImageAttribute",
              "ec2:ModifyInstanceAttribute",
              "ec2:ModifyLaunchTemplate",
              "ec2:ModifySnapshotAttribute",
              "ec2:RegisterImage",
              "ec2:RunInstances",
              "ec2:StopInstances",
              "ec2:TerminateInstances",
              "events:DescribeRule",
              "events:ListTagsForResource",
              "events:ListTargetsByRule",
              "iam:GetInstanceProfile",
              "iam:GetRole",
              "iam:GetRolePolicy",
              "iam:ListAttachedRolePolicies",
              "iam:ListRolePolicies",
              "ssm:GetParameter",
              "ssm:GetParameters"
            ],
            "Resource": "*"
        },
        {
          "Effect": "Allow",
          "Action": "iam:PassRole",
          "Resource": [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.environment}-bind-server-role"
          ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "private_role" {
  count = var.create_private_role ? 1 : 0

  policy_arn = aws_iam_policy.private[0].arn
  role       = aws_iam_role.private_role[0].name
}
