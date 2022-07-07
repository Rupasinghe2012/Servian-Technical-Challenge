module "bastion" {
  source = "../../../../modules/aws-bastion/"

  app_name = var.app_name
  ## Lauch Configurations
  ami_id        = data.aws_ami.bastion_ami.id
  instance_type = var.bastion_instance_type

  instance_security_groups = [module.bastion_sg.sg_id]
  instance_keypair         = module.key-pair.key_name
  block_volume_size        = var.block_volume_size

  ## AutoScaling Group
  asg_desired_capacity = var.asg_desired_capacity
  asg_max_size         = var.asg_max_size
  asg_min_size         = var.asg_min_size
  subnet_ids           = module.vpc.private_subnets

  tags = var.tags
}
