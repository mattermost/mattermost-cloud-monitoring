resource "aws_iam_user" "packer" {
  count = var.create_packer_user ? 1 : 0

  name = "mattermost-cloud-${var.environment}-packer"
  path = "/"
}

resource "aws_iam_policy" "packer" {
  count = var.create_packer_user ? 1 : 0

  name        = "mattermost-cloud-${var.environment}-packer-policy"
  description = "A policy attached to packer IAM user"
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
            "Sid": "S3Policy",
            "Effect": "Allow",
            "Action": [
                "s3:GetObjectAttributes",
                "s3:ListBucket",
                "s3:GetObjectLegalHold",
                "s3:GetObjectVersionAttributes",
                "s3:GetObjectVersionTorrent",
                "s3:GetObject",
                "s3:GetObjectTorrent",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectTagging",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::terraform-cloud-monitoring-state-bucket-${var.environment}/*",
                "arn:aws:s3:::terraform-cloud-monitoring-state-bucket-${var.environment}"
            ]
        },
        {
            "Sid": "AllOtherServicesPolicy",
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:DescribeInstances",
                "ec2:CreateImage",
                "ec2:CopyImage",
                "ec2:DescribeSnapshots",
                "ssm:GetParameter",
                "ec2:DeleteVolume",
                "ec2:ModifySnapshotAttribute",
                "iam:ListAttachedRolePolicies",
                "ec2:DescribeVolumes",
                "ec2:DescribeKeyPairs",
                "iam:ListRolePolicies",
                "events:ListTargetsByRule",
                "ec2:DetachVolume",
                "iam:GetRole",
                "events:DescribeRule",
                "ec2:DescribeLaunchTemplates",
                "ec2:CreateTags",
                "ec2:RegisterImage",
                "ec2:CreateKeypair",
                "ec2:RunInstances",
                "ec2:StopInstances",
                "ec2:CreateVolume",
                "ec2:GetPasswordData",
                "ec2:DescribeImageAttribute",
                "events:ListTagsForResource",
                "ec2:DescribeSubnets",
                "ec2:DeleteKeyPair",
                "iam:GetRolePolicy",
                "ec2:AttachVolume",
                "ec2:DeregisterImage",
                "ec2:DeleteSnapshot",
                "ec2:DescribeRegions",
                "ec2:ModifyImageAttribute",
                "ec2:DescribeVpcAttribute",
                "ec2:DescribeNetworkInterfaces",
                "ec2:CreateSecurityGroup",
                "ec2:CreateSnapshot",
                "ec2:ModifyInstanceAttribute",
                "ec2:DescribeInstanceStatus",
                "ec2:TerminateInstances",
                "iam:GetInstanceProfile",
                "ec2:DescribeTags",
                "ec2:DescribeLaunchTemplateVersions",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeImages",
                "ec2:DescribeVpcs",
                "ec2:DeleteSecurityGroup",
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeLifecycleHooks"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "packer" {
  count = var.create_packer_user ? 1 : 0

  user       = aws_iam_user.packer[0].name
  policy_arn = aws_iam_policy.packer[0].arn
}

