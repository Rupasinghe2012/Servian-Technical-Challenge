#General
app_name     = "servian"
aws_region   = "us-east-1"
environment  = "dev"
keypair_name = "servian-key"

# VPC
vpc_cidr         = "10.34.16.0/20"
azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_subnets   = ["10.34.16.0/24", "10.34.19.0/24", "10.34.22.0/24"]
private_subnets  = ["10.34.17.0/24", "10.34.20.0/24", "10.34.23.0/24"]
database_subnets = ["10.34.18.0/24", "10.34.21.0/24", "10.34.24.0/24"]

# Bastion
bastion_instance_type = "t3.micro"
block_volume_size = 50
asg_desired_capacity = 1
asg_min_size = 1
asg_max_size = 1

# Tags
tags = {
  "Client"      = "servian",
  "Project"     = "servian-demo",
  "Environment" = "dev"
}
