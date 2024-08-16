resource "cloudflare_record" "pexip_conference" {
  zone_id = var.cloudflare_zone_id
  name    = var.conference_cloudflare_record_name
  value   = aws_eip.pexip_conference_eip.public_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "pexip_management" {
  zone_id = var.cloudflare_zone_id
  name    = var.management_cloudflare_record_name
  value   = aws_eip.pexip_management_eip.public_ip
  type    = "A"
  proxied = true
}
