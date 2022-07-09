variable "environment" {
  default = "test"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "20.10.0.0/16"
}

variable "app_name" {
  default = "servian"
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["20.10.11.0/24", "20.10.12.0/24", "20.10.13.0/24"]
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = ["20.10.1.0/24", "20.10.2.0/24", "20.10.3.0/24"]
}

variable "database_subnets" {
  description = "A list of private subnets inside the VPC dedicated for Databases"
  type        = list(string)
  default     = ["20.10.21.0/24", "20.10.22.0/24", "20.10.23.0/24"]
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "additional_pub_sn_tags" {
  description = "Required map(string). AWS tags."
  type        = map(string)
  default = {
    "subnetType" = "public"
  }
}

variable "additional_priv_sn_tags" {
  description = "Required map(string). AWS tags."
  type        = map(string)
  default = {
    "subnetType" = "private"
  }
}

variable "keypair_name" {
  description = "Keypair name"
  type        = string
  default     = "test"
}

variable "bastion_instance_type" {
  description = "Instance type for Bastion"
  type        = string
  default     = "t2.medium"
}

variable "block_volume_size" {
  description = "Root volume size"
  type        = string
  default     = 300
}

variable "asg_desired_capacity" {
  description = "Autoscaling group desired capacity"
  type        = string
  default     = 1
}

variable "asg_max_size" {
  description = "Autoscaling group maximum size"
  type        = string
  default     = 1
}

variable "asg_min_size" {
  description = "Autoscaling group minimum size"
  type        = string
  default     = 1
}

variable "postgres_rds_vars" {
  description = "PostgreSQL RDS Variables"
  type        = map(any)
  default = {
    storage                    = "20"
    engine                     = "postgres"
    engine_version             = "13.6"
    auto_minor_version_upgrade = false
    instance_class             = "db.t2.micro"
    instance_identifier        = "servian-postgres-dev"
    final_snapshot_identifier  = "servian-postgres-dev-snapshot"
    port                       = "5432"
    defaultdb                  = "postgres_dev"
    public_access              = false
    enable_multi_az            = true
    ca_cert_identifier         = "rds-ca-2019"
    rds_subnet_group_name      = "servian-us-east-1-dev"
    pg_description             = "servian Dev RDS Parameter Group for PostgreSQL 13"
    pg_name                    = "servian-dev-postgres13"
    pg_rds_family              = "postgres13"
    username                   = "postgres"
    az                         = "us-east-1c"
  }

}

variable "cert_dns_name" {
  type    = string
  default = "*.ap-southeast-2.elb.amazonaws.com"
}

variable "cert_org_name" {
  type    = string
  default = "servian"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = ""
}

variable "cluster_version" {
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.22`)"
  type        = string
  default     = null
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = false
}

variable "enable_irsa" {
  description = "Determines whether to create an OpenID Connect Provider for EKS to enable IRSA"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Required map(string). AWS tags."
  type        = map(string)
  default     = {}
}
