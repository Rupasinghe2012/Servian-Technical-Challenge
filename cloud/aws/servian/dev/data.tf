data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ami" "bastion_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
