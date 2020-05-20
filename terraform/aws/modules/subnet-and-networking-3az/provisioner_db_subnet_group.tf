resource "aws_db_subnet_group" "provisioner_db_subnet_group" {

  for_each = toset(var.vpc_cidrs)

  name = "mattermost-provisioner-db-${data.aws_vpc.vpc_ids[each.value]["id"]}"

  subnet_ids = [
    aws_subnet.private_1a[each.value]["id"],
    aws_subnet.private_1b[each.value]["id"],
    aws_subnet.private_1c[each.value]["id"]
  ]

  tags = merge(
    {
      "MattermostCloudInstallationDatabase" = "MYSQL/Aurora"
    },
    var.tags
  )
}
