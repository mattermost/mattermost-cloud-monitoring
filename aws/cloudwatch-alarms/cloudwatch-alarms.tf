// Lambda to receive the Alarms via SNS topic
resource "aws_iam_role" "lambda_role_receive_elb_cloudwatch_alarm" {
  name = "receive_elb_cloudwatch_alarm"

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

resource "aws_iam_role_policy" "lambda_policy_receive_elb_cloudwatch_alarm" {
  name = "receive_elb_cloudwatch_alarm_policy"
  role = aws_iam_role.lambda_role_receive_elb_cloudwatch_alarm.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:DeleteAlarms"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole_alert" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role_receive_elb_cloudwatch_alarm.name
}

resource "aws_lambda_function" "alert_elb_cloudwatch_alarm" {
  s3_bucket     = "releases.mattermost.com"
  s3_key        = "mattermost-cloud/alert-elb-cloudwatch-alarm/master/main.zip"
  function_name = "receive-elb-cloudwatch-alarm"
  role          = aws_iam_role.lambda_role_receive_elb_cloudwatch_alarm.arn
  handler       = "main"
  timeout       = 120
  runtime       = "go1.x"

  environment {
    variables = {
      MATTERMOST_HOOK         = var.community_webhook
      OPSGENIE_APIKEY         = var.opsgenie_apikey
      OPSGENIE_SCHEDULER_TEAM = var.opsgenie_scheduler_team
      ENVIRONMENT             = var.environment
    }
  }

}

// SNS topic
resource "aws_sns_topic" "elb_alarm_topic" {
  name = "elb-alarm-topic"

  depends_on = [
    aws_lambda_function.alert_elb_cloudwatch_alarm
  ]
}


// SNS topic that the alarm will be sent
resource "aws_sns_topic_subscription" "lamba_subscriber" {
  topic_arn = aws_sns_topic.elb_alarm_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.alert_elb_cloudwatch_alarm.arn

  depends_on = [
    aws_lambda_function.alert_elb_cloudwatch_alarm
  ]
}


// Lambda to create the Cloudwatch alarms
resource "aws_iam_role" "lambda_role_create_elb_cloudwatch_alarm" {
  count = var.environment == "test" ? 0 : 1

  name = "create_elb_cloudwatch_alarm"

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

resource "aws_iam_role_policy" "lambda_policy_create_elb_cloudwatch_alarm" {
  count = var.environment == "test" ? 0 : 1

  name = "create_elb_cloudwatch_alarm_policy"
  role = aws_iam_role.lambda_role_create_elb_cloudwatch_alarm[0].id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:DeleteAlarms"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeTargetGroups"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole_create" {
  count = var.environment == "test" ? 0 : 1

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role_create_elb_cloudwatch_alarm[0].name
}

resource "aws_lambda_function" "create_elb_cloudwatch_alarm" {
  count = var.environment == "test" ? 0 : 1

  s3_bucket     = "releases.mattermost.com"
  s3_key        = "mattermost-cloud/create-elb-cloudwatch-alarm/master/main.zip"
  function_name = "create-elb-cloudwatch-alarm"
  role          = aws_iam_role.lambda_role_create_elb_cloudwatch_alarm[0].arn
  handler       = "main"
  timeout       = 120
  runtime       = "go1.x"

  environment {
    variables = {
      SNS_TOPIC = aws_sns_topic.elb_alarm_topic[0].arn,
    }
  }

  depends_on = [
    aws_sns_topic_subscription.lamba_subscriber
  ]
}

// Cloudwatch rule to be triggered when a LB is deleted or created
resource "aws_cloudwatch_event_rule" "lb_updates" {
  count = var.environment == "test" ? 0 : 1

  name          = "lb-registration"
  description   = "Runs when a new LB is deleted or created"
  event_pattern = <<PATTERN
    {
      "source": [
        "aws.elasticloadbalancing"
      ],
      "detail-type": [
        "AWS API Call via CloudTrail"
      ],
      "detail": {
        "eventSource": [
          "elasticloadbalancing.amazonaws.com"
        ],
        "eventName": [
          "CreateLoadBalancer",
          "DeleteLoadBalancer"
        ]
      }
    }
  PATTERN

  depends_on = [
    aws_lambda_function.create_elb_cloudwatch_alarm
  ]
}

resource "aws_cloudwatch_event_target" "lb-registration" {
  count = var.environment == "test" ? 0 : 1

  rule      = aws_cloudwatch_event_rule.lb_updates[0].name
  target_id = "create-elb-cloudwatch-alarm"
  arn       = aws_lambda_function.create_elb_cloudwatch_alarm[0].arn

  depends_on = [
    aws_lambda_function.create_elb_cloudwatch_alarm
  ]
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lb_registration" {
  count = var.environment == "test" ? 0 : 1

  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_elb_cloudwatch_alarm[0].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lb_updates[0].arn

  depends_on = [
    aws_lambda_function.create_elb_cloudwatch_alarm
  ]
}

//
// Lambda to create the Cloudwatch alarms for RDS
//
resource "aws_iam_role" "lambda_role_create_rds_cloudwatch_alarm" {
  name = "create_rds_cloudwatch_alarm"

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

resource "aws_iam_role_policy" "lambda_policy_create_rds_cloudwatch_alarm" {
  name = "create_rds_cloudwatch_alarm_policy"
  role = aws_iam_role.lambda_role_create_rds_cloudwatch_alarm.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:DeleteAlarms"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
          "rds:DescribeDBClusters"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole_rds_create" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role_create_rds_cloudwatch_alarm.name
}

resource "aws_lambda_function" "create_rds_cloudwatch_alarm" {
  s3_bucket     = "releases.mattermost.com"
  s3_key        = "mattermost-cloud/create-rds-cloudwatch-alarm/master/main.zip"
  function_name = "create-rds-cloudwatch-alarm"
  role          = aws_iam_role.lambda_role_create_rds_cloudwatch_alarm.arn
  handler       = "main"
  timeout       = 120
  runtime       = "go1.x"

  environment {
    variables = {
      SNS_TOPIC = aws_sns_topic.elb_alarm_topic.arn,
    }
  }

  depends_on = [
    aws_sns_topic_subscription.lamba_subscriber
  ]
}

// Cloudwatch rule to be triggered when a LB is deleted or created
resource "aws_cloudwatch_event_rule" "rds_updates" {
  name          = "rds-registration"
  description   = "Runs when a new RDS is deleted or created"
  event_pattern = <<PATTERN
    {
      "source": [
        "aws.rds"
      ],
      "detail-type": [
        "AWS API Call via CloudTrail"
      ],
      "detail": {
        "eventSource": [
          "rds.amazonaws.com"
        ],
        "eventName": [
          "CreateDBInstance",
          "DeleteDBInstance"
        ]
      }
    }
  PATTERN

  depends_on = [
    aws_lambda_function.create_rds_cloudwatch_alarm
  ]
}

resource "aws_cloudwatch_event_target" "rds-registration" {
  rule      = aws_cloudwatch_event_rule.rds_updates.name
  target_id = "create-rds-cloudwatch-alarm"
  arn       = aws_lambda_function.create_rds_cloudwatch_alarm.arn

  depends_on = [
    aws_lambda_function.create_rds_cloudwatch_alarm
  ]
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_rds_registration" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_rds_cloudwatch_alarm.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.rds_updates.arn

  depends_on = [
    aws_lambda_function.create_rds_cloudwatch_alarm
  ]
}
