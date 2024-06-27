module "calico" {

    source = "github.com/mattermost/mattermost-cloud-monitoring.git//aws/eks-customer/calico?ref=v1.7.11"

    cluster_name = module.eks.cluster_name
    cluster_endpoint = module.eks.cluster_endpoint
    cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
    calico_operator_version = var.calico_operator_version
    cluster_arn = module.eks.cluster_arn
    region = var.region
}