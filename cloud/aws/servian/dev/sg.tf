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

module "postgre_rds_sg" {
  source = "../../../../modules/aws-sg"

  vpc_id           = module.vpc.vpc_id
  application_name = var.app_name
  environment      = var.environment
  role             = "db"

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
      from_port : var.postgres_rds_vars["port"],
      to_port : var.postgres_rds_vars["port"],
      protocol : "tcp",
      source : ["${chomp(data.http.myip.body)}/32"]
      description : "Default DB Port"
    },
  ]
  rules_with_security_group_as_source = [
    {
      rule_type : "ingress",
      from_port : var.postgres_rds_vars["port"],
      to_port : var.postgres_rds_vars["port"],
      protocol : "tcp",
      source : module.bastion_sg.sg_id
      description : "Bastion DB Access"
    },
    {
      rule_type : "ingress",
      from_port : var.postgres_rds_vars["port"],
      to_port : var.postgres_rds_vars["port"],
      protocol : "tcp",
      source : module.eks.cluster_security_group_id
      description : "EKS Access"
    },
    {
      rule_type : "ingress",
      from_port : var.postgres_rds_vars["port"],
      to_port : var.postgres_rds_vars["port"],
      protocol : "tcp",
      source : module.eks.node_security_group_id
      description : "EKS Access"
    },
  ]
  tags = var.tags
}
