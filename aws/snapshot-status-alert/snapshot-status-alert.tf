data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_event_rule" "snapshot_status_alert" {
  name        = "snapshot-status-alert"
  description = "Capture snapshot status errors and alert"

  event_pattern = jsonencode({
    "source" : ["aws.ec2"],
    "detail-type" : ["EBS Snapshot Notification"],
    "detail" : {
      "result" : ["failed"]
    }
  })
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.snapshot_status_alert.name
  target_id = "SendToSNS"
  arn       = "arn:aws:sns:us-east-1:${data.aws_caller_identity.current.account_id}:elb-alarm-topic"
}
