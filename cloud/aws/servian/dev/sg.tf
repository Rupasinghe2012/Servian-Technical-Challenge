module "bastion_sg" {
  source = "../../../../modules/aws-sg"

  vpc_id           = module.vpc.vpc_id
  application_name = var.app_name
  environment      = var.environment
  role             = "bastion"

  rules_with_cidr_as_source = [
    {
      rule_type : "egress",
      from_port : "0",
      to_port : "65535",
      protocol : "-1",
      source : ["0.0.0.0/0"]
      description : "Allow all outbound traffic"
    },
    {
      rule_type : "ingress",
      from_port : "22",
      to_port : "22",
      protocol : "tcp",
      source : ["${chomp(data.http.myip.body)}/32"]
      description : "SSH access"
    }
  ]

  tags = var.tags
}
