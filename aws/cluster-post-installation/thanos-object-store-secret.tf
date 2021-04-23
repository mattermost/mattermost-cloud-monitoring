resource "kubernetes_secret" "thanos_objstore_config" {
  metadata {
    name      = "thanos-objstore-config"
    namespace = "monitoring"

  }

  data = {
    "thanos.yaml" = <<EOF
type: s3
config: 
  bucket: ${aws_s3_bucket.metrics_bucket.id}
  endpoint: s3.us-east-1.amazonaws.com
    EOF 
  }

  type = "Opaque"
}
