data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  conditional_dash_region = data.aws_region.current.name == "us-east-1" ? "" : "-${data.aws_region.current.name}"
}
