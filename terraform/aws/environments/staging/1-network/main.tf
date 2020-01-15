
terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "terraform-cloud-monitoring-state-bucket-staging"
    key    = "mattermost-network"
    region = "us-east-1"
  }
}


provider "aws" {
  region = var.region
  alias  = "deployment"
}

module "shared_services_vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc"
  
  name = "mattermost-cloud-test-shared-services"
  cidr = var.shared_vpc_cidr

  azs             = var.shared_vpc_azs
  private_subnets = var.shared_vpc_private_subnets_cidrs
  public_subnets  = var.shared_vpc_public_subnets_cidrs

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  tags = {
    Owner = "cloud-team"
    Terraform = "true"
    Environment = var.environment
  }
  providers = {
    aws = "aws.deployment"
  }
}

module "tgw_attachment" {
  source  = "../../../modules/transit-gateway"
  subnet_ids = module.shared_services_vpc.private_subnets
  transit_gateway_id = var.transit_gateway_id
  vpc_id = module.shared_services_vpc.vpc_id
  private_route_table_id = module.shared_services_vpc.private_route_table_ids[0]
  public_route_table_id = module.shared_services_vpc.public_route_table_ids[0]
  transit_gtw_route_destination = var.transit_gtw_route_destination
}

resource "aws_route53_zone_association" "shared_services_association" {
  zone_id = var.private_hosted_zone_id
  vpc_id  = module.shared_services_vpc.vpc_id
}


module "bind-server" {
  source  = "../../../modules/bind-server"
  name = "dns"
  ami = var.bind_server_ami
  environment = var.environment
  ssh_key_public = var.ssh_key_public
  vpc_id = module.shared_services_vpc.vpc_id
  cidr_blocks = var.bind_cidr_blocks
  vpn_cidr = var.vpn_cidr
  subnet_ids = module.shared_services_vpc.private_subnets
  private_ips  = var.private_dns_ips
  ssh_key = var.ssh_key
  providers = {
    aws = "aws.deployment"
  }
}

#This section is not used yet. It will be used to automate the deployment of C&C and Auth VPCs
##########################################
# module "command_control_vpc" {
#   source = "github.com/terraform-aws-modules/terraform-aws-vpc"
  
#   name = "mattermost-cloud-test-command-control"
#   cidr = var.command_control_vpc_cidr

#   azs             = var.command_control_vpc_azs
#   private_subnets = var.command_control_vpc_private_subnets_cidrs
#   public_subnets  = var.command_control_vpc_public_subnets_cidrs

#   enable_nat_gateway = true
#   single_nat_gateway = true
#   enable_dns_hostnames = true

#   tags = {
#     Owner = "cloud-team"
#     Terraform = "true"
#     Environment = var.environment
#   }
#   providers = {
#     aws = "aws.deployment"
#   }
# }

# module "tgw_attachment" {
#   source  = "../../../modules/transit-gateway"
#   subnet_ids = module.command_control_vpc.private_subnets
#   transit_gateway_id = var.transit_gateway_id
#   vpc_id = module.command_control_vpc.vpc_id
#   route_table_id = module.command_control_vpc.private_route_table_ids[0]
# }

# module "auth_vpc" {
#   source = "github.com/terraform-aws-modules/terraform-aws-vpc"
  
#   name = "mattermost-cloud-test-auth"
#   cidr = var.auth_vpc_cidr

#   azs             = var.auth_vpc_azs
#   private_subnets = var.auth_vpc_private_subnets_cidrs
#   public_subnets  = var.auth_vpc_public_subnets_cidrs

#   enable_nat_gateway = true
#   single_nat_gateway = true
#   enable_dns_hostnames = true

#   tags = {
#     Owner = "cloud-team"
#     Terraform = "true"
#     Environment = var.environment
#   }
#   providers = {
#     aws = "aws.deployment"
#   }
# }

# module "tgw_attachment" {
#   source  = "../../../modules/transit-gateway"
#   subnet_ids = module.auth_vpc.private_subnets
#   transit_gateway_id = var.transit_gateway_id
#   vpc_id = module.auth_vpc.vpc_id
#   route_table_id = module.auth_vpc.private_route_table_ids[0]
# }
##########################################
