locals {
  vpc_name = "${var.app_name}-${data.aws_region.current.name}-${var.environment}"
  region   = data.aws_region.current.name
}

# Provision VPC, Subnets, Route tables, NAT gateway, IAM for flow logs
module "vpc" {
  source = "../../../../modules/aws-vpc/"

  name                 = local.vpc_name
  cidr                 = var.vpc_cidr
  azs                  = var.azs
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  database_subnets     = var.database_subnets
  enable_nat_gateway   = true
  enable_dns_hostnames = true

  enable_flow_log           = true
  flow_log_destination_type = "cloud-watch-logs"

  tags = var.tags

  # Tags differ for Public and Private subnets for Kubernetes
  private_subnet_tags = var.cluster_name != null ? merge(
    { "kubernetes.io/role/internal-elb" = "1" },
    { "kubernetes.io/cluster/${var.cluster_name}" = "shared" },
    var.additional_priv_sn_tags
  ) : merge(var.additional_priv_sn_tags)
  public_subnet_tags = var.cluster_name != null ? merge(
    { "kubernetes.io/role/elb" = "1" },
    { "kubernetes.io/cluster/${var.cluster_name}" = "shared" },
    var.additional_pub_sn_tags
  ) : merge(var.additional_pub_sn_tags)
}
