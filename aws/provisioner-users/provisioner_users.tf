resource "aws_iam_user" "provisioner_users" {
  for_each = toset(var.provisioner_users)
  name     = each.value
  path     = "/"

}
