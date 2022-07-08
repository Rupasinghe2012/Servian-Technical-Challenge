resource "tls_private_key" "self_ssl" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "self_ssl" {
  private_key_pem = tls_private_key.self_ssl.private_key_pem

  subject {
    common_name  = var.cert_dns_name
    organization = var.cert_org_name
  }

  validity_period_hours = 8784

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "self_ssl_cert" {
  private_key      = tls_private_key.self_ssl.private_key_pem
  certificate_body = tls_self_signed_cert.self_ssl.cert_pem
}
