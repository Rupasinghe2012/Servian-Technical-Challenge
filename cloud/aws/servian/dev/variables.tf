variable "environment" {
  default = "test"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "20.10.0.0/16"
}

variable "app" {
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

variable "tags" {
  description = "Required map(string). AWS tags."
  type        = map(string)
  default     = {}
}
