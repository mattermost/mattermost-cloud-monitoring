resource "aws_network_interface" "pexip_management" {
  subnet_id       = var.private_subnet_id
  private_ips     = var.management_private_ips
  security_groups = [aws_security_group.pexip_management_sg.id]
}

resource "aws_instance" "pexip_management" {
  ami           = var.initial_configuration ? var.official_pexip_management_ec2_ami : var.custom_management_ec2_ami
  instance_type = var.management_ec2_type
  key_name      = var.initial_configuration ? var.ec2_key_pair : ""

  network_interface {
    network_interface_id = aws_network_interface.pexip_management.id
    device_index         = 0
  }

  tags = {
    "Name" = "${var.name}-management"
  }
}

# First conference node
resource "aws_network_interface" "pexip_conference_first" {
  subnet_id       = var.public_subnet_id
  private_ips     = [var.conference_private_ips[0]]
  security_groups = [aws_security_group.pexip_conference_sg.id]
}

resource "aws_instance" "pexip_conference_first" {
  ami           = var.initial_configuration ? var.official_pexip_conference_ec2_ami : var.custom_conference_ec2_ami
  instance_type = var.conference_ec2_type_first
  key_name      = var.initial_configuration ? var.ec2_key_pair : ""
  tenancy       = "dedicated"

  network_interface {
    network_interface_id = aws_network_interface.pexip_conference_first.id
    device_index         = 0
  }

  tags = {
    "Name" = "${var.name}-conference-first"
  }
}

resource "aws_eip_association" "pexip_conference_first" {
  instance_id   = aws_instance.pexip_conference_first.id
  allocation_id = aws_eip.pexip_conference_eip_first.id
}

resource "aws_eip" "pexip_conference_eip_first" {
  tags = merge(
    {
      "Name" = "${var.name}-conference-eip-first"
    }
  )
}

# Second conference node
resource "aws_network_interface" "pexip_conference_second" {
  subnet_id       = var.public_subnet_id
  private_ips     = [var.conference_private_ips[1]]
  security_groups = [aws_security_group.pexip_conference_sg.id]
}

resource "aws_instance" "pexip_conference_second" {
  ami           = var.initial_configuration ? var.official_pexip_conference_ec2_ami : var.custom_conference_ec2_ami
  instance_type = var.conference_ec2_type_second
  key_name      = var.initial_configuration ? var.ec2_key_pair : ""
  tenancy       = "dedicated"

  network_interface {
    network_interface_id = aws_network_interface.pexip_conference_second.id
    device_index         = 0
  }

  tags = {
    "Name" = "${var.name}-conference-second"
  }
}

resource "aws_eip_association" "pexip_conference_second" {
  instance_id   = aws_instance.pexip_conference_second.id
  allocation_id = aws_eip.pexip_conference_eip_second.id
}

resource "aws_eip" "pexip_conference_eip_second" {
  tags = merge(
    {
      "Name" = "${var.name}-conference-eip-second"
    }
  )
}
