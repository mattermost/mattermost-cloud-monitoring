resource "aws_iam_role" "cleanup_old_images_lambda" {
  name                  = "cleanup_old_images_lambda"
  path                  = "/"
  force_detach_policies = false

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "cleanup_old_images_lambda_policy" {
  name = "cleanup_old_images_lambda_policy"
  role = aws_iam_role.cleanup_old_images_lambda.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
        "Effect": "Allow",
        "Action": [
            "xray:PutTraceSegments",
            "xray:PutTelemetryRecords",
            "ec2:CreateNetworkInterface",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface",
            "ec2:DescribeImages",
            "ec2:DeregisterImage",
            "ec2:DescribeInstances",
            "ebs:DescribeSnapshots",
            "ebs:DeleteSnapshot"
        ],
        "Resource": [
            "*"
        ]
        },
        {
            "Effect" : "Allow",
            "Action" : [
                "cloudwatch:PutMetricData"
            ],
            "Resource" : "*"
        }
    ]
}
EOF

}