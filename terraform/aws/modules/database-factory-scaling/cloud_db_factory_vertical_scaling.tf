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
        "${data.aws_caller_identity.current.account_id}",
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

# Vertical scaling microservice cron job
resource "kubernetes_cron_job" "cloud_db_factory_vertical_scaling_cron" {
  metadata {
    name      = "cloud-db-factory-vertical-scaling"
    namespace = var.mattermost_cloud_namespace
  }
  spec {
    concurrency_policy            = "Allow"
    failed_jobs_history_limit     = 5
    successful_jobs_history_limit = 2
    schedule                      = var.vertical_scaling_cronjob_schedule
    suspend                       = false

    job_template {
      metadata {}
      spec {
        ttl_seconds_after_finished = 86400
        template {
          metadata {}
          spec {
            container {
              name              = "cloud-db-factory-vertical-scaling"
              image             = var.cloud_db_factory_vertical_scaling_image
              image_pull_policy = "Always"

              env {
                name  = "RDSMultitenantDBInstanceNamePrefix"
                value = var.rds_multitenant_dbinstance_name_prefix
              }

              env {
                name  = "MattermostNotificationsHook"
                value = var.mattermost_notifications_hook
              }

              env {
                name  = "MattermostAlertsHook"
                value = var.mattermost_alerts_hook
              }

              env {
                name  = "QueueURL"
                value = aws_sqs_queue.vertical_scaling_sqs_queue.id
              }

              env {
                name = "AWS_SECRET_ACCESS_KEY"

                value_from {
                  secret_key_ref {
                    name = kubernetes_secret.cloud_db_factory_vertical_scaling_secret.metadata[0].name
                    key  = "AWS_SECRET_ACCESS_KEY"
                  }
                }
              }

              env {
                name = "AWS_ACCESS_KEY_ID"

                value_from {
                  secret_key_ref {
                    name = kubernetes_secret.cloud_db_factory_vertical_scaling_secret.metadata[0].name
                    key  = "AWS_ACCESS_KEY_ID"
                  }
                }
              }

              env {
                name = "AWS_DEFAULT_REGION"

                value_from {
                  secret_key_ref {
                    name = kubernetes_secret.cloud_db_factory_vertical_scaling_secret.metadata[0].name
                    key  = "AWS_REGION"
                  }
                }
              }

              env {
                name = "AWS_REGION"

                value_from {
                  secret_key_ref {
                    name = kubernetes_secret.cloud_db_factory_vertical_scaling_secret.metadata[0].name
                    key  = "AWS_REGION"
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  # Will be added in the future when managed by flux
  #   lifecycle {
  #     ignore_changes = [
  #       metadata,
  #       spec,
  #     ]
  #   }
}

resource "kubernetes_secret" "cloud_db_factory_vertical_scaling_secret" {
  metadata {
    name      = "cloud-db-factory-vertical-scaling-secret"
    namespace = var.mattermost_cloud_namespace
  }

  data = {
    AWS_ACCESS_KEY_ID     = var.cloud_db_factory_vs_secrets_aws_access_key
    AWS_SECRET_ACCESS_KEY = var.cloud_db_factory_vs_secrets_aws_secret_key
    AWS_REGION            = var.cloud_db_factory_vs_secrets_aws_region
  }

  type = "Opaque"

  # Will be added in the future when managed by flux
  #   lifecycle {
  #     ignore_changes = [
  #       metadata,
  #       data,
  #       type,
  #     ]
  #   }
}
