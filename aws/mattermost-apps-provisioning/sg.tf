resource "aws_security_group" "lambda_sg" {
  name        = "${var.deployment_name}-lambda-sg"
  description = "Security group used by Mattermost apps Lambda Functions"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.deployment_name}-lambda-sg"
  }
}
