resource "aws_iam_role" "generic-webhook" {
  name                  = "generic-webhook"
  path                  = "/"
  force_detach_policies = false

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
      }
    ]
  })
}

resource "aws_iam_role_policy" "generic-webhook-lambda-policy" {
  name = "generic-webhook-lambda-policy"
  role = aws_iam_role.generic-webhook.id

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
            "ec2:DescribeImages",
            "ec2:DeregisterImage",
            "ec2:DescribeInstances",
            "ec2:DescribeSnapshots",
            "ec2:DeleteSnapshot",
            "ec2:CreateNetworkInterface",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface"
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
