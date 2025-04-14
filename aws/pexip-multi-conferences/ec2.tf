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

# Conference nodes
resource "aws_network_interface" "pexip_conference" {
  for_each = var.conference_nodes

  subnet_id       = var.public_subnet_id
  private_ips     = [each.value.private_ip]
  security_groups = [aws_security_group.pexip_conference_sg.id]
}

resource "aws_instance" "pexip_conference" {
  for_each = var.conference_nodes

  ami           = var.initial_configuration ? var.official_pexip_conference_ec2_ami : each.value.ami_id
  instance_type = each.value.ec2_type
  key_name      = var.initial_configuration ? var.ec2_key_pair : ""
  tenancy       = "dedicated"

  network_interface {
    network_interface_id = aws_network_interface.pexip_conference[each.key].id
    device_index         = 0
  }

  tags = {
    "Name" = "${var.name}-conference-${each.key}"
  }
}

resource "aws_eip" "pexip_conference_eip" {
  for_each = var.conference_nodes

  tags = {
    "Name" = "${var.name}-conference-eip-${each.key}"
  }
}

resource "aws_eip_association" "pexip_conference" {
  for_each = var.conference_nodes

  instance_id   = aws_instance.pexip_conference[each.key].id
  allocation_id = aws_eip.pexip_conference_eip[each.key].id
}
