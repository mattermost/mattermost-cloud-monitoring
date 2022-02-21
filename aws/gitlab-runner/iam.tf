resource "aws_iam_policy" "s3" {
  name        = "mattermost-gitlab-runner-policy"
  path        = "/"
  description = "S3 Permissions for gitlab runners"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "route53",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObjectVersion",
                "s3:GetObject",
                "s3:DeleteObjec"
            ],
            "Resource": "${aws_s3_bucket.gitlab_runners.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_role" "s3_role" {
  name = "mattermost-gitlab-runner-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
       "Principal": {
        "AWS": [ "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.eks_workers_role_name}" ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "role_attach_s3" {
  role       = aws_iam_role.s3_role.name
  policy_arn = aws_iam_policy.s3.arn
}
