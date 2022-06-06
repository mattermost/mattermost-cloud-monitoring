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
  tags = var.tags
}
