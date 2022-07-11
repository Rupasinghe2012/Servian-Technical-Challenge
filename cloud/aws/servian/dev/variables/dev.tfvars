#General
app_name     = "servian"
aws_region   = "ap-southeast-2"
environment  = "dev"
keypair_name = "servian-keypair"

# VPC
vpc_cidr         = "10.34.16.0/20"
azs              = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
public_subnets   = ["10.34.16.0/24", "10.34.19.0/24", "10.34.22.0/24"]
private_subnets  = ["10.34.17.0/24", "10.34.20.0/24", "10.34.23.0/24"]
database_subnets = ["10.34.18.0/24", "10.34.21.0/24", "10.34.24.0/24"]

# Bastion
bastion_instance_type = "t3.micro"
block_volume_size     = 50
asg_desired_capacity  = 1
asg_min_size          = 1
asg_max_size          = 1

# Postgres RDS
postgres_rds_vars = {
  storage                    = "20"
  engine                     = "postgres"
  engine_version             = "13.6"
  auto_minor_version_upgrade = false
  instance_class             = "db.t3.micro"
  instance_identifier        = "servian-postgres-dev"
  final_snapshot_identifier  = "servian-postgres-dev-snapshot"
  port                       = "5432"
  defaultdb                  = "postgres_dev"
  public_access              = false
  enable_multi_az            = true
  ca_cert_identifier         = "rds-ca-2019"
  rds_subnet_group_name      = "servian-ap-southeast-2-dev"
  pg_description             = "servian Dev RDS Parameter Group for PostgreSQL 13"
  pg_name                    = "servian-dev-postgres13"
  pg_rds_family              = "postgres13"
  username                   = "postgres"
}

# Self-signed Certificate
cert_dns_name = "*.ap-southeast-2.elb.amazonaws.com"
cert_org_name = "servian"

# EKS Cluster
cluster_name                    = "servian"
cluster_version                 = 1.22
cluster_endpoint_private_access = true
cluster_endpoint_public_access  = false
enable_irsa                     = true

# Servian Build
eks_arn_user_list = ["arn:aws:iam::380811051426:user/iruka"]
domain_name       = "preprod-dev.servian.cloud"

# Tags
tags = {
  "Client"      = "servian",
  "Project"     = "servian-demo",
  "Environment" = "dev"
}
