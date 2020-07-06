resource "aws_iam_policy" "sqs_db_factory_vertical_scaling" {
  name        = "db-factory-vertical-scaling-sqs-policy"
  path        = "/"
  description = "SQS permissions for database factory vertical scaling user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "sqs0",
            "Effect": "Allow",
            "Action": [
                "sqs:DeleteMessage",
                "sqs:ReceiveMessage"
            ],
            "Resource": "${aws_sqs_queue.vertical_scaling_sqs_queue.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "rds_db_factory_vertical_scaling" {
  name        = "db-factory-vertical-scaling-tag-policy"
  path        = "/"
  description = "RDS permissions for database factory vertical scaling user"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "rds0",
            "Effect": "Allow",
            "Action": [
                "rds:Describe*",
                "rds:FailoverDBCluster"
            ],
            "Resource": "*"
        },
         {
            "Sid": "rds1",
            "Effect": "Allow",
            "Action": [
                "rds:ModifyDBInstance"
            ],
            "Resource": "arn:aws:rds:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:db:${var.rds_multitenant_dbinstance_name_prefix}-*"
        }
        
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "attach_sqs_db_factory_vertical_scaling" {
  for_each = toset(var.db_factory_vertical_scaling_users)
  user     = each.value

  policy_arn = aws_iam_policy.sqs_db_factory_vertical_scaling.arn
}

resource "aws_iam_user_policy_attachment" "attach_rds_db_factory_vertical_scaling" {
  for_each   = toset(var.db_factory_vertical_scaling_users)
  user       = each.value
  policy_arn = aws_iam_policy.rds_db_factory_vertical_scaling.arn
}
