# Generating Self-signed certificate and uploading it to ACM 
module alb_self_signed_certificate {
  source = "../../../../modules/aws-selfsigned-acm"

  cert_dns_name = var.cert_dns_name
  cert_org_name = var.cert_org_name
}
