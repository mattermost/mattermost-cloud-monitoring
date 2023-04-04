module "bind-server" {
  source         = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/bind-server?ref=1.6.0"
  name           = "dns"
  ami            = var.bind_server_ami
  environment    = var.environment
  ssh_key_public = var.ssh_key_public
  vpc_id         = module.shared_services_vpc.vpc_id
  cidr_blocks    = var.bind_cidr_blocks
  vpn_cidr       = var.vpn_cidr
  subnet_ids     = module.shared_services_vpc.private_subnets
  private_ips    = var.private_dns_ips
  ssh_key        = var.ssh_key
  teleport_cidr  = var.teleport_cidr
}
