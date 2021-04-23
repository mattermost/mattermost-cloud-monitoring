data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_sns_topic" "vertical_scaling_sns_topic" {
  name = "cloud-db-factory-vertical-scaling-${var.environment}"
}

resource "aws_sqs_queue" "vertical_scaling_sqs_queue" {
  name                              = "cloud-db-factory-vertical-scaling-${var.environment}"
  visibility_timeout_seconds        = 1000
  message_retention_seconds         = 864000
  kms_data_key_reuse_period_seconds = 300
  tags = {
    Environment = var.environment
  }
}

resource "aws_sns_topic_subscription" "vertical_scaling_sns_topic_subscription" {
  topic_arn = aws_sns_topic.vertical_scaling_sns_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.vertical_scaling_sqs_queue.arn
}


resource "aws_sqs_queue_policy" "vertical_scaling_sqs_queue_policy" {
  queue_url = aws_sqs_queue.vertical_scaling_sqs_queue.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.vertical_scaling_sqs_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.vertical_scaling_sns_topic.arn}"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_sns_topic_policy" "vertical_scaling_sns_topic_policy" {
  arn = aws_sns_topic.vertical_scaling_sns_topic.arn

  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        data.aws_caller_identity.current.account_id,
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.vertical_scaling_sns_topic.arn,
    ]

    sid = "__default_statement_ID"
  }

  statement {
    actions = [
      "SNS:Publish"
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_caller_identity.current.account_id}"]
    }

    resources = [
      aws_sns_topic.vertical_scaling_sns_topic.arn,
    ]

    sid = "AllowPublishAccount"
  }
}
