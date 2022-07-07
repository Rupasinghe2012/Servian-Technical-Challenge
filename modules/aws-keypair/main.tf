resource "tls_private_key" "my_tls" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "private_key_pem" {
  source = "../aws-secret/"

  secret_name  = "/${var.keypair_name}/ssh/private_key_pem"
  secret_value = tls_private_key.my_tls.private_key_pem

  tags = merge(var.tags, {
    Name = var.keypair_name
  })
}

module "public_key_pem" {
  source = "../aws-secret/"

  secret_name  = "/${var.keypair_name}/ssh/public_key_pem"
  secret_value = tls_private_key.my_tls.public_key_pem

  tags = merge(var.tags, {
    Name = var.keypair_name
  })
}

resource "aws_key_pair" "key_pair" {
  keypair_name = var.keypair_name
  public_key   = module.public_key_pem.secret_value
}
