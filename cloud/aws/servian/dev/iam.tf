# IAM Role for Bastion Server ---------------------------------------------------------------
data "template_file" "bastion_policy_data" {
  template = file("policies/bastion_policy.json.tpl")
}

module "bastion_role_policy" {
  source = "../../../../modules/aws-iam/iam-policy"

  policy_name     = "bastion-ec2"
  description     = "Role Policy for Bastion-EC2 Instances"
  policy_template = data.template_file.bastion_policy_data.rendered

  tags = merge(var.tags, {
    Name = "bastion-ec2"
  })
}

module "bastion_role" {
  source = "../../../../modules/aws-iam/iam-role"

  role_name          = "Bastion-EC2"
  description        = "Role for Bastion-EC2 Instances"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ec2.json
  role_policy_arns   = [module.bastion_role_policy.arn]

  tags = merge(var.tags, {
    Name = "Bastion-EC2"
  })
}

# IAM Role for Fargate Profiles ---------------------------------------------------------------

module "fargate_profile_role" {
  source = "../../../../modules/aws-iam/iam-role"

  role_name          = "fargate_profile_role"
  description        = "Role for Fargate Profile"
  assume_role_policy = data.aws_iam_policy_document.assume_role_fargate.json
  role_policy_arns   = ["arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]

  tags = merge(var.tags, {
    Name = "fargate_profile_role"
  })
}
