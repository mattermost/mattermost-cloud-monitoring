data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_iam_role" "lambda_role" {
  name = "${var.deployment_name}-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.lambda_role.name
}


resource "aws_iam_policy" "mattermost_apps_cloud_invoke_policy" {
  name        = "mattermost-apps-cloud-invoke-policy"
  path        = "/"
  description = "IAM user permissions for Mattermost apps cloud invoke user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:ListBucketVersions",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "${aws_s3_bucket.bucket.arn}"
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
                "${aws_s3_bucket.bucket.arn}/*"
            ]
        },
        {
            "Sid": "DenyLamda",
            "Effect": "Deny",
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": [
              "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:license-test-validate-license",
              "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:license-test-generate-license",
              "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:deckhand",
              "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:rds-cluster-events",
              "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:account-alerts",
              "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:grafana-aws-metrics",
              "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:create-elb-cloudwatch-alarm",
              "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:receive-elb-cloudwatch-alarm",
              "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:create-rds-cloudwatch-alarm",
              "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:cloud-server-auth",
              "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:AWSBudget-Mattermost",
              "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:bind-server-network-attachment",
              "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:Cloud-${title(var.environment)}-Health"
            ]
        },
        {
            "Sid": "AllowLamda",
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "attach_mattermost_apps_cloud_invoke_user_policy" {
  user       = aws_iam_user.mattermost_apps_cloud_invoke_user.name
  policy_arn = aws_iam_policy.mattermost_apps_cloud_invoke_policy.arn
}

resource "aws_iam_user" "mattermost_apps_cloud_invoke_user" {
  name = "mattermost-apps-cloud-invoke"
  path = "/"
}
