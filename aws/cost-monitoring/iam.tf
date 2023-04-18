resource "aws_iam_user" "cost-report-user" {
  name = "mattermost-cost-report-${var.environment}"
  path = "/"
}

resource "aws_iam_policy" "cost-report-policy" {
  name        = "cost-report-policy"
  path        = "/"
  description = "Permissions for cost reporting"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ce:*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF

}

resource "aws_iam_user_policy_attachment" "attachment" {
  user       = aws_iam_user.cost-report-user.name
  policy_arn = aws_iam_policy.cost-report-policy.arn
}
