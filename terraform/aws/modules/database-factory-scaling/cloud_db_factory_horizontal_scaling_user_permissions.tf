resource "aws_iam_policy" "ec2_db_factory_horizontal_scaling" {
  name        = "db-factory-horizontal-scaling-ec2-policy"
  path        = "/"
  description = "EC2 permissions for database factory horizontal scaling user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "kms0",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVpc*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "tag_db_factory_horizontal_scaling" {
  name        = "db-factory-horizontal-scaling-tag-policy"
  path        = "/"
  description = "Resource Group Tagging permissions for database factory horizontal scaling user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "tag0",
            "Effect": "Allow",
            "Action": [
                "tag:GetResources"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "attach_ec2_db_factory_horizontal_scaling" {
  for_each = toset(var.db_factory_horizontal_scaling_users)
  user     = each.value

  policy_arn = aws_iam_policy.ec2_db_factory_horizontal_scaling.arn
}

resource "aws_iam_user_policy_attachment" "attach_tag_db_factory_horizontal_scaling" {
  for_each   = toset(var.db_factory_horizontal_scaling_users)
  user       = each.value
  policy_arn = aws_iam_policy.tag_db_factory_horizontal_scaling.arn
}
