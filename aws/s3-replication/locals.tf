provider "aws" {
  alias  = "source"
  region = local.source.region
}

provider "aws" {
  alias  = "destination"
  region = local.destination.region
}

locals {
  source = {
    region = var.source_region
  }
  destination = {
    region = var.destination_region
  }
}
