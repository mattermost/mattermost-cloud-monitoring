resource "aws_iam_role" "rudderstack-role" {
  name               = "rudderstack-s3-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::422074288268:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${var.workspace_id}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_policy" "rudderstack-policy" {
  name        = "rudderstack-s3-policy"
  description = "S3 permissions for rudderstack role"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.bucket_name}/*"
    }
  ]
}

EOF
}

resource "aws_iam_role_policy_attachment" "rudderstack-policy-attach" {
  role       = aws_iam_role.rudderstack-role.name
  policy_arn = aws_iam_policy.rudderstack-policy.arn
}
