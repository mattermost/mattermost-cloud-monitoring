
resource "aws_iam_user" "this" {
  count = var.create_user ? 1 : 0

  name                 = var.name
  path                 = var.path
  force_destroy        = var.force_destroy
  permissions_boundary = var.permissions_boundary

  tags = var.tags
}

resource "aws_iam_policy" "this" {
  name        = "${var.name}-policy"
  description = "A policy attached to ${var.name} IAM user"
  path        = "/"
  policy      = var.policy
}

resource "aws_iam_user_policy_attachment" "this" {
  count = var.create_iam_policy ? 1 : 0

  user       = aws_iam_user.this[0].name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_user_login_profile" "this" {
  count = var.create_user && var.create_iam_user_login_profile ? 1 : 0

  user                    = aws_iam_user.this[0].name
  password_length         = var.password_length
  password_reset_required = var.password_reset_required

  # TODO: Remove once https://github.com/hashicorp/terraform-provider-aws/issues/23567 is resolved
  lifecycle {
    ignore_changes = [password_reset_required]
  }
}

resource "aws_iam_access_key" "this" {
  count = var.create_user && var.create_iam_access_key ? 1 : 0

  user   = aws_iam_user.this[0].name
  status = var.iam_access_key_status
}

resource "aws_iam_user_ssh_key" "this" {
  count = var.create_user && var.upload_iam_user_ssh_key ? 1 : 0

  username   = aws_iam_user.this[0].name
  encoding   = var.ssh_key_encoding
  public_key = var.ssh_public_key
}
