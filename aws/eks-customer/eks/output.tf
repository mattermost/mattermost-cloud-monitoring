output "private_subnet_ids" {
  value = [data.aws_subnets.private.ids]
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_version" {
  value = module.eks.cluster_version
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "cluster_service_cidr" {
  value = module.eks.cluster_service_cidr
}

output "cluster_primary_security_group_id" {
  value = module.eks.cluster_primary_security_group_id
}

output "node_security_group_id" {
  value = module.eks.node_security_group_id
}