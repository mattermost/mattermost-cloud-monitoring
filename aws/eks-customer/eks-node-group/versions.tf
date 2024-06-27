terraform {
  required_version = ">= 1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.41.0"
    }
    # helm = {
    #   source  = "hashicorp/helm"
    #   version = ">= 2.7"
    # }
    # tls = {
    #   source  = "hashicorp/tls"
    #   version = ">= 4.0.0"
    # }
  }
}