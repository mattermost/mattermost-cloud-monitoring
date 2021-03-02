
resource "aws_security_group" "es_sg" {
  name        = "Elasticsearch Service SG"
  description = "The security group of the Elasticsearch Service"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = concat(var.vpn_cidr, var.mattermost_network)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = concat(var.vpn_cidr, var.mattermost_network)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
