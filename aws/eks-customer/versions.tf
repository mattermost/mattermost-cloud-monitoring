terraform {
  required_version = ">= 1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.41.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.1"
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