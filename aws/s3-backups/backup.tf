data "aws_vpc" "vpc_ids" {
  for_each   = toset(var.vpc_cidrs)
  cidr_block = each.value
}

data "aws_s3_bucket" "s3_buckets" {
  for_each = toset(var.vpc_cidrs)
  bucket   = format("%s-%s", var.name, data.aws_vpc.vpc_ids[each.value]["id"])
}

data "aws_kms_key" "backup_s3" {
  key_id = var.s3_backup_kms_key
}

resource "aws_backup_plan" "backup_plan" {
  for_each = toset(var.vpc_cidrs)

  name = format("%s-%s", var.name, join("", split(".", split("/", each.value)[0])))

  rule {
    rule_name         = "s3_backup_rule"
    target_vault_name = aws_backup_vault.backup_vault[each.value]["name"]
    schedule          = var.s3_backup_cron

    lifecycle {
      delete_after = var.s3_backup_retention
    }
  }
}

resource "aws_backup_vault" "backup_vault" {
  for_each = toset(var.vpc_cidrs)

  name        = format("%s-%s", var.name, join("", split(".", split("/", each.value)[0])))
  kms_key_arn = data.aws_kms_key.backup_s3.arn
}

resource "aws_backup_selection" "backup_selection" {
  for_each = toset(var.vpc_cidrs)

  iam_role_arn = aws_iam_role.backup_iam_role.arn
  name         = format("%s-%s", var.name, join("", split(".", split("/", each.value)[0])))
  plan_id      = aws_backup_plan.backup_plan[each.value]["id"]

  resources = [
    data.aws_s3_bucket.s3_buckets[each.value]["arn"]
  ]
}
