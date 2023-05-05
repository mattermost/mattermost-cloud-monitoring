resource "aws_iam_user" "apps_deployer" {
  count = var.create_apps_deployer_user ? 1 : 0

  name = "mattermost-cloud-apps-deployer-${var.environment}"
  path = "/"
}

resource "aws_iam_policy" "apps_deployer" {
  count = var.create_apps_deployer_user ? 1 : 0

  name        = "mattermost-cloud-apps-deployer-policy"
  path        = "/"
  description = "Permissions for apps deployer service"

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
            "Resource": [
                "arn:aws:s3:::mattermost-apps-assets-bucket-${var.environment}",
                "arn:aws:s3:::mattermost-apps-terraform-state-bucket-${var.environment}",
                "arn:aws:s3:::terraform-cloud-monitoring-state-bucket-${var.environment}"
            ]
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
            "Resource": [
                "arn:aws:s3:::mattermost-apps-assets-bucket-${var.environment}/*",
                "arn:aws:s3:::mattermost-apps-terraform-state-bucket-${var.environment}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:GetObjectVersionAcl"
            ],
            "Resource": [
                "arn:aws:s3:::terraform-cloud-monitoring-state-bucket-${var.environment}/*"
            ]
        },
        {
            "Sid": "AllowLamdaDeploymentLogs",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:DescribeLogGroups",
                "logs:PutRetentionPolicy",
                "logs:PutSubscriptionFilter"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowLamdaDeploymentEC2",
            "Effect": "Allow",
            "Action": [
                "ec2:Describe*",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:DeleteSecurityGroup",
                "ec2:CreateSecurityGroup",
                "ec2:CreateTags",
                "ec2:AuthorizeSecurityGroup*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowLamdaDeploymentIAM",
            "Effect": "Allow",
            "Action": [
                "iam:Get*",
                "iam:List*",
                "iam:PassRole"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowLamdaDeployment",
            "Effect": "Allow",
            "Action": [
                "lambda:CreateFunction*",
                "lambda:TagResource",
                "lambda:UntagResource",
                "lambda:List*",
                "lambda:Update*",
                "lambda:DeleteFunctionEventInvokeConfig",
                "lambda:PublishVersion",
                "lambda:GetAccountSettings",
                "lambda:GetEventSourceMapping",
                "lambda:CreateEventSourceMapping",
                "lambda:GetFunction*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "STSAssumeRole",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "${var.apps_deployer_assume_role_arn}"
        }
    ]
}
EOF

}

resource "aws_iam_user_policy_attachment" "apps_deployer_attachment" {
  count = var.create_apps_deployer_user ? 1 : 0

  user       = aws_iam_user.apps_deployer[0].name
  policy_arn = aws_iam_policy.apps_deployer[0].arn
}
