## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | ~> 3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.argocd](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.awat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.blackbox](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.chaos_mesh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.chimera](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.customer_web_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.customer_web_server_api_internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.customer_web_server_internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.database_factory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.grafana](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.kubecost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.loki_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.prometheus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.provisioner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.push_proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.thanos](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [cloudflare_record.customer_web_server](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [kubernetes_service.nginx-private](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |
| [kubernetes_service.nginx-public](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudflare_customer_webserver_cdn"></a> [cloudflare\_customer\_webserver\_cdn](#input\_cloudflare\_customer\_webserver\_cdn) | The cloudflare CDN to proxy | `string` | n/a | yes |
| <a name="input_cloudflare_zone_id"></a> [cloudflare\_zone\_id](#input\_cloudflare\_zone\_id) | The Cloudflare zone ID provided | `string` | n/a | yes |
| <a name="input_cws_cloudflare_record_name"></a> [cws\_cloudflare\_record\_name](#input\_cws\_cloudflare\_record\_name) | The Cloudflare DNS record name for customer web server | `string` | n/a | yes |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | EKS Cluster deployment name | `string` | n/a | yes |
| <a name="input_enable_awat_record"></a> [enable\_awat\_record](#input\_enable\_awat\_record) | Enables to create a private route53 record for private AWAT | `bool` | n/a | yes |
| <a name="input_enable_chaos_record"></a> [enable\_chaos\_record](#input\_enable\_chaos\_record) | Enables to create a private route53 record for private ChaosMesh | `bool` | n/a | yes |
| <a name="input_enable_chimera_record"></a> [enable\_chimera\_record](#input\_enable\_chimera\_record) | Enables to create a public route53 record for private Chimera | `bool` | n/a | yes |
| <a name="input_enable_kubecost_record"></a> [enable\_kubecost\_record](#input\_enable\_kubecost\_record) | Enables to create a public route53 record for private Kubecost | `bool` | n/a | yes |
| <a name="input_enable_loki_gateway"></a> [enable\_loki\_gateway](#input\_enable\_loki\_gateway) | Enables to create a private route53 record for Loki Gateway | `bool` | n/a | yes |
| <a name="input_enable_portal_internal_r53_record"></a> [enable\_portal\_internal\_r53\_record](#input\_enable\_portal\_internal\_r53\_record) | Enables to create a internal CNAME route53 record for Internal Customer Web Serve API | `bool` | n/a | yes |
| <a name="input_enable_portal_private_r53_record"></a> [enable\_portal\_private\_r53\_record](#input\_enable\_portal\_private\_r53\_record) | Enables to create a private CNAME route53 record for Private Customer Web Server | `bool` | n/a | yes |
| <a name="input_enable_portal_public_r53_record"></a> [enable\_portal\_public\_r53\_record](#input\_enable\_portal\_public\_r53\_record) | Enables to create a public route53 record for public Customer Web Server | `bool` | n/a | yes |
| <a name="input_enable_push_proxy_record"></a> [enable\_push\_proxy\_record](#input\_enable\_push\_proxy\_record) | Enables to create a private route53 record for Mattermost Push Proxy | `bool` | n/a | yes |
| <a name="input_enabled_cloudflare_customer_web_server"></a> [enabled\_cloudflare\_customer\_web\_server](#input\_enabled\_cloudflare\_customer\_web\_server) | Enables cloudflare for Customer Web Server | `bool` | n/a | yes |
| <a name="input_private_hosted_zoneid"></a> [private\_hosted\_zoneid](#input\_private\_hosted\_zoneid) | The AWS private hosted zone ID | `string` | n/a | yes |
| <a name="input_public_hosted_zoneid"></a> [public\_hosted\_zoneid](#input\_public\_hosted\_zoneid) | The AWS public hosted zone ID | `string` | n/a | yes |

## Outputs

No outputs.
