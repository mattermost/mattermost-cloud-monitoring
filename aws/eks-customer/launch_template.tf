resource "aws_launch_template" "node" {
  for_each = { for k, v in var.node_groups : k => v }


  name        = "${each.key}-${module.eks.cluster_name}"
  description = "${each.key}-${module.eks.cluster_name} cluster nodes launch template"

  # This is to avoid conflicts with the EKS managed node group: InvalidRequestException: Network interfaces and an instance-level security groups may not be specified on the same request
  vpc_security_group_ids = length(each.value.network_interfaces) > 0 ? [] : compact(concat([module.eks.cluster_primary_security_group_id], strcontains(each.key, "calls") ? data.aws_security_groups.calls.ids : data.aws_security_groups.nodes.ids))

  block_device_mappings {
    device_name = var.device_name
    ebs {
      volume_size           = var.volume_size
      volume_type           = var.volume_type
      iops                  = var.volume_iops
      throughput            = var.volume_throughput
      encrypted             = var.volume_encrypted
      delete_on_termination = var.volume_delete_on_termination
    }
  }

  dynamic "network_interfaces" {
    for_each = each.value.network_interfaces

    content {
      associate_carrier_ip_address = try(network_interfaces.value.associate_carrier_ip_address, null)
      associate_public_ip_address  = try(network_interfaces.value.associate_public_ip_address, null)
      delete_on_termination        = try(network_interfaces.value.delete_on_termination, null)
      description                  = try(network_interfaces.value.description, null)
      device_index                 = try(network_interfaces.value.device_index, null)
      interface_type               = try(network_interfaces.value.interface_type, null)
      ipv4_address_count           = try(network_interfaces.value.ipv4_address_count, null)
      ipv4_addresses               = try(network_interfaces.value.ipv4_addresses, [])
      ipv4_prefix_count            = try(network_interfaces.value.ipv4_prefix_count, null)
      ipv4_prefixes                = try(network_interfaces.value.ipv4_prefixes, null)
      ipv6_address_count           = try(network_interfaces.value.ipv6_address_count, null)
      ipv6_addresses               = try(network_interfaces.value.ipv6_addresses, [])
      ipv6_prefix_count            = try(network_interfaces.value.ipv6_prefix_count, null)
      ipv6_prefixes                = try(network_interfaces.value.ipv6_prefixes, [])
      network_card_index           = try(network_interfaces.value.network_card_index, null)
      network_interface_id         = try(network_interfaces.value.network_interface_id, null)
      primary_ipv6                 = try(network_interfaces.value.primary_ipv6, null)
      private_ip_address           = try(network_interfaces.value.private_ip_address, null)
      # Ref: https://github.com/hashicorp/terraform-provider-aws/issues/4570
      security_groups = compact(concat(try(network_interfaces.value.security_groups, []), compact(concat([module.eks.cluster_primary_security_group_id], strcontains(each.key, "calls") ? data.aws_security_groups.calls.ids : data.aws_security_groups.nodes.ids))))
      # Set on EKS managed node group, will fail if set here
      # https://docs.aws.amazon.com/eks/latest/userguide/launch-templates.html#launch-template-basics
      # subnet_id       = try(network_interfaces.value.subnet_id, null)
    }
  }

  image_id      = var.use_al2023 ? each.value.al2023_ami_id : each.value.ami_id
  instance_type = element(each.value.instance_types, 0)
  ebs_optimized = var.ebs_optimized

  user_data = var.use_al2023 ? base64encode(<<USERDATA
#!/bin/bash
echo "export AWS_REGION=${data.aws_region.current.name}" >> /etc/environment
source /etc/environment
cat <<EOF > /etc/eks/nodeadm-config.yaml
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${module.eks.cluster_name}
    apiServerEndpoint: |
      ${module.eks.cluster_endpoint}
    certificateAuthority: |
      ${module.eks.cluster_certificate_authority_data}
    cidr: ${module.eks.cluster_service_cidr}
EOF

/usr/local/bin/nodeadm init -c file:///etc/eks/nodeadm-config.yaml
USERDATA
    ) : base64encode(<<USERDATA
#!/bin/bash
set -e
B64_CLUSTER_CA=${module.eks.cluster_certificate_authority_data}
API_SERVER_URL=${module.eks.cluster_endpoint}
/etc/eks/bootstrap.sh ${module.eks.cluster_name}  --b64-cluster-ca $B64_CLUSTER_CA --apiserver-endpoint $API_SERVER_URL \
  --ip-family ipv4 --service-ipv4-cidr ${module.eks.cluster_service_cidr}
USERDATA
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name              = "${each.key}-${module.eks.cluster_name}"
      KubernetesCluster = module.eks.cluster_name
      VpcID             = var.vpc_id
    }
  }
}
