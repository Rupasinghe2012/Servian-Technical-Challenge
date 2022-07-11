variable "bastion_public_ip_enabled" {
  description = "Enable or disable public IP association for Bastion"
  type        = string
  default     = true
}

variable "iam_instance_profile" {
  description = "IAM instance profile for the EKS workers"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for Bastion"
  type        = string
  default     = "ami-098f49793dc110d98"
}

variable "instance_type" {
  description = "Instance type for Bastion"
  type        = string
  default     = "t2.medium"
}

variable "instance_security_groups" {
  description = "Bastion nodes security groups"
  type        = list(string)
}

variable "instance_keypair" {
  description = "Bastion instance keypair name"
  type        = string
  default     = "AWS-NONPROD"
}

variable "block_volume_size" {
  description = "Root volume size"
  type        = string
  default     = 300
}

variable "volume_type" {
  description = "Root volume type"
  type        = string
  default     = "gp3"
}

variable "block_delete_on_termination" {
  description = "Delete block volumen on termination"
  type        = string
  default     = true
}

variable "app_name" {
  description = "ApplicationName tag value"
  type        = string
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

variable "subnet_ids" {
  description = "List of subnet IDs. Must be in at least two different availability zones."
  type        = list(string)
}

variable "tags" {
  type        = map(any)
  description = "AWS tags"
  default     = {}
}
