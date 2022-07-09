# Assume Role Policy - EKS --------------------------------------------------------------------------------
data "aws_iam_policy_document" "k8s_assume_policy" {
  statement {
    sid     = "1"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${module.eks.oidc_provider}"]
    }

    condition {
      test     = "StringLike"
      variable = "${module.eks.oidc_provider}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
  statement {
    sid     = "3"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM Role for K8s Cluster External DNS -------------------------------------
data "template_file" "external_dns_policy_data" {
  template = file("policies/k8s_external_dns.json.tpl")
}

module "external_dns_policy" {
  source = "../../../../modules/aws-iam/iam-policy"

  policy_name     = "external_dns_policy"
  description     = "Route53 external dns policy"
  policy_template = data.template_file.external_dns_policy_data.rendered

  tags = merge(var.tags, {
    Name = "external_dns_policy"
  })
}

module "external_dns_role" {
  source = "../../../../modules/aws-iam/iam-role"

  role_name          = "external_dns_role"
  description        = "Route53 external dns Role"
  assume_role_policy = data.aws_iam_policy_document.k8s_assume_policy.json
  role_policy_arns   = [module.external_dns_policy.arn]

  tags = merge(var.tags, {
    Name = "external_dns_role"
  })
}

# IAM Role for K8s Cluster lb_controller -------------------------------------
data "template_file" "lb_controller_policy_data" {
  template = file("policies/k8s_lb_controller.json.tpl")
}

module "lb_controller_policy" {
  source = "../../../../modules/aws-iam/iam-policy"

  policy_name     = "lb_controller_policy"
  description     = "LB controller policy"
  policy_template = data.template_file.lb_controller_policy_data.rendered

  tags = merge(var.tags, {
    Name = "lb_controller_policy"
  })
}

module "lb_controller_role" {
  source = "../../../../modules/aws-iam/iam-role"

  role_name          = "lb_controller_role"
  description        = "LB controller Role"
  assume_role_policy = data.aws_iam_policy_document.k8s_assume_policy.json
  role_policy_arns   = [module.lb_controller_policy.arn]

  tags = merge(var.tags, {
    Name = "lb_controller_role"
  })
}
