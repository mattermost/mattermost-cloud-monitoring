resource "aws_iam_policy" "mattermost_apps_cloud_deployer_user_policy" {
  name        = "mattermost-apps-cloud-deployer-policy"
  path        = "/"
  description = "IAM user permissions for Mattermost apps cloud deployer user"

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
                "arn:aws:s3:::${var.static_bucket}",
                "arn:aws:s3:::${var.terraform_state_bucket}",
                "arn:aws:s3:::terraform-cloud-monitoring-state-bucket-test"
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
                "arn:aws:s3:::${var.static_bucket}/*",
                "arn:aws:s3:::${var.terraform_state_bucket}/*"
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
                "arn:aws:s3:::terraform-cloud-monitoring-state-bucket-test/*"
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
            "Resource": "${var.apps_assumed_role}"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "attach_mattermost_apps_cloud_deployer_user_policy" {
  user       = aws_iam_user.mattermost_apps_cloud_deployer_user.name
  policy_arn = aws_iam_policy.mattermost_apps_cloud_deployer_user_policy.arn
}

resource "aws_iam_user" "mattermost_apps_cloud_deployer_user" {
  name = "mattermost-apps-cloud-deployer"
  path = "/"
}

resource "aws_iam_access_key" "mattermost_apps_cloud_deployer_user" {
  user = aws_iam_user.mattermost_apps_cloud_deployer_user.name
}
