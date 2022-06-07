resource "aws_iam_role" "promtail_lambda" {
  name = "promtail_lambda"

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

resource "aws_iam_role_policy" "logs" {
  name = "lambda-logs"
  role = aws_iam_role.promtail_lambda.name
  policy = jsonencode({
    "Statement" : [
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        "Effect" : "Allow",
        "Resource" : "arn:aws:logs:*:*:*",
      },
      {
        "Action" : [
          "s3:GetObject",
        ],
        "Effect" : "Allow",
        "Resource" : [
          for bucket in toset(var.bucket_names) : "arn:aws:s3:::${bucket}/*"
        ]
      }
    ]
  })
}

data "aws_iam_policy" "lambda_vpc_execution" {
  name = "AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_execution" {
  role       = aws_iam_role.promtail_lambda.name
  policy_arn = data.aws_iam_policy.lambda_vpc_execution.arn
}
