terraform {
  required_version = ">= 1.6.3"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.25.0"
    }
  }
}
