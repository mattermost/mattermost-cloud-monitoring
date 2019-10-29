data "kubernetes_service" "nginx-internal" {
  metadata {
    name = "mattermost-cm-nginx-internal-nginx-ingress-controller"
    namespace = "network"
  }
}

data "kubernetes_service" "nginx" {
  metadata {
    name = "mattermost-cm-nginx-nginx-ingress-controller"
    namespace = "network"
  }
}

#Public records
resource "aws_route53_record" "prometheus" {
  zone_id = "${var.private_hosted_zoneid}"
  name    = "prometheus"
  type    = "CNAME"
  ttl     = "60"
  records = ["${data.kubernetes_service.nginx-internal.load_balancer_ingress.0.hostname}"]
}

resource "aws_route53_record" "grafana" {
  zone_id = "${var.private_hosted_zoneid}"
  name    = "grafana"
  type    = "CNAME"
  ttl     = "60"
  records = ["${data.kubernetes_service.nginx-internal.load_balancer_ingress.0.hostname}"]
}

resource "aws_route53_record" "kibana" {
  zone_id = "${var.private_hosted_zoneid}"
  name    = "kibana"
  type    = "CNAME"
  ttl     = "60"
  records = ["${data.kubernetes_service.nginx-internal.load_balancer_ingress.0.hostname}"]
}

resource "aws_route53_record" "auth" {
  zone_id = "${var.private_hosted_zoneid}"
  name    = "auth"
  type    = "CNAME"
  ttl     = "60"
  records = ["${data.kubernetes_service.nginx-internal.load_balancer_ingress.0.hostname}"]
}

resource "aws_route53_record" "elasticsearch" {
  zone_id = "${var.private_hosted_zoneid}"
  name    = "elasticsearch"
  type    = "CNAME"
  ttl     = "60"
  records = ["${data.kubernetes_service.nginx-internal.load_balancer_ingress.0.hostname}"]
}

resource "aws_route53_record" "provisioner" {
  zone_id = "${var.private_hosted_zoneid}"
  name    = "provisioner"
  type    = "CNAME"
  ttl     = "60"
  records = ["${data.kubernetes_service.nginx.load_balancer_ingress.0.hostname}"]
}
