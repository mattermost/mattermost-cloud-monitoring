resource "aws_db_subnet_group" "provisioner_db_subnet_group" {

for_each = toset(var.vpc_cidrs)

name       = "mattermost-provisioner-db-sg-${join("", split(".", split("/", each.value)[0]))}"
  
subnet_ids         = [
    aws_subnet.private_1a[each.value]["id"],
    aws_subnet.private_1b[each.value]["id"],
    aws_subnet.private_1c[each.value]["id"],
    aws_subnet.private_1d[each.value]["id"],
    aws_subnet.private_1e[each.value]["id"],
    aws_subnet.private_1f[each.value]["id"]
]

tags = {
    DBSubnetGroupType = "provisioning"
    }
}
