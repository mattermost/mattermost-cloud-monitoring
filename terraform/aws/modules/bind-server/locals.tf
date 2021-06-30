locals {
  role_policy_arn = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
  ]

  aws_sns_topic_arn = "arn:aws:sns:us-east-1:${data.aws_caller_identity.current.account_id}:elb-alarm-topic"
}