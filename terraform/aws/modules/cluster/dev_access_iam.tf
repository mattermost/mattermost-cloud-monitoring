data "aws_caller_identity" "current" {}

resource "aws_iam_role" "dev_access_role" {
  name = "${var.deployment_name}-dev-access-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "dev_access_role" {
  name = "cluster_dev_access_policy"
  role = aws_iam_role.dev_access_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ID0",
            "Effect": "Allow",
            "Action": "eks:DescribeCluster",
            "Resource": "arn:aws:eks:us-east-1:${data.aws_caller_identity.current.account_id}:cluster/${var.deployment_name}"
        }
    ]
}
EOF
}


