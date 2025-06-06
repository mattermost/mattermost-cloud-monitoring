data "aws_caller_identity" "current" {}

resource "aws_iam_user" "lambda_user" {
  name = "mattermost-cloud-lambdas-upload-${var.environment}"
  path = "/"
}

resource "aws_iam_role" "lambda_role" {
  name = "mattermost-cloud-lambdas-upload-${var.environment}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = [
          "sts:AssumeRoleWithWebIdentity"
        ]
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" : ["repo:mattermost/mattermost-cloud-lambdas:environment:${var.environment}"]
          }
          StringEquals = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "s3" {
  name        = "mattermost-cloud-lambdas-upload-${var.environment}"
  path        = "/"
  description = "S3 upload permissions for mattermost-cloud-lambda"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:ListBucketVersions",
                "s3:GetBucketLocation",
                "s3:GetBucketTagging"
            ],
            "Resource": [
                "arn:aws:s3:::mattermost-cloud-lambdas-${var.environment}"
            ]
        },
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:GetObjectVersionAcl"
            ],
            "Resource": [
                "arn:aws:s3:::mattermost-cloud-lambdas-${var.environment}/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "attach_s3" {
  user       = aws_iam_user.lambda_user.name
  policy_arn = aws_iam_policy.s3.arn
}


resource "aws_iam_role_policy_attachment" "attach_s3" {
  policy_arn = aws_iam_policy.s3.arn
  role       = aws_iam_role.lambda_role.name
}