module "key-pair" {
  source = "../../../../modules/aws-keypair/"

  keypair_name = var.keypair_name
}
