resource "random_id" "cluster" {
  byte_length = 4
}

locals {
  cluster_id      = random_id.cluster.hex
  internal_domain = "internal.${var.environment}.${var.private_domain}"
}
