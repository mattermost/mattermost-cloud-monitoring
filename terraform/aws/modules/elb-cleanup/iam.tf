resource "aws_iam_role" "elb_cleanup_lambda_role" {
  name = "elb_cleanup_lambda_role"

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

resource "aws_iam_role_policy" "elb_cleanup_lambda_policy" {
  name = "elb_cleanup__lambda_policy"
  role = aws_iam_role.elb_cleanup_lambda_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
            "elasticloadbalancing:*"
        ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRoleELBCleanup" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.elb_cleanup_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRoleELBCleanup" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.elb_cleanup_lambda_role.name
}
