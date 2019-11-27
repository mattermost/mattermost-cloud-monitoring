data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket   = "terraform-cloud-monitoring-state-bucket-${var.environment}"
    key      = "mattermost-network"
    region   = "us-east-1"
  }
}

resource "aws_security_group_rule" "master_egress_udp" {
  cidr_blocks       = var.vpc_cidrs
  description       = "Inbound Traffic from Provisioning VPC"
  from_port         = 53
  protocol          = "udp"
  security_group_id = data.terraform_remote_state.network.outputs.bind_sg
  to_port           = 53
  type              = "ingress"
}

resource "aws_security_group_rule" "master_egress_tcp" {
  cidr_blocks       = var.vpc_cidrs
  description       = "Inbound Traffic from Provisioning VPC"
  from_port         = 53
  protocol          = "tcp"
  security_group_id = data.terraform_remote_state.network.outputs.bind_sg
  to_port           = 53
  type              = "ingress"
}
