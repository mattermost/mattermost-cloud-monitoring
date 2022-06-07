provider "aws" {
  alias  = "primary"
  region = local.primary.region
}

provider "aws" {
  alias  = "secondary"
  region = local.secondary.region
}

locals {
  primary = {
    region = var.source_region
  }
  secondary = {
    region = var.target_region
  }
  final_snapshot_identifier = "${var.global_cluster_identifier}-${formatdate("YYYYMMDDhhmm",timestamp())}"
}
