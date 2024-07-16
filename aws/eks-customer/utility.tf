resource null_resource "deploy-utilites" {
  for_each = var.utilities
  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/deploy-utility.sh ${each.value.name} ${each.value.type}"
  }
}