################################################################################
# EKS Module
################################################################################

module "eks" {
  source = "../../../../modules/aws-eks/"

  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  enable_irsa                     = var.enable_irsa

  # cluster_addons = {
  #   # Note: https://docs.aws.amazon.com/eks/latest/userguide/fargate-getting-started.html#fargate-gs-coredns
  #   coredns = {
  #     resolve_conflicts = "OVERWRITE"
  #   }
  #   kube-proxy = {}
  #   vpc-cni = {
  #     resolve_conflicts = "OVERWRITE"
  #   }
  # }
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
    ingress_bastion_http = {
      description              = "443"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      type                     = "ingress"
      source_security_group_id = module.bastion_sg.sg_id
    }
  }

  fargate_profile_defaults = {
    create_iam_role = false
    iam_role_arn    = module.fargate_profile_role.iam_role_arn
  }

  fargate_profiles = {
    fp-coredns = {
      name = "fp-coredns"
      selectors = [
        {
          namespace = "kube-system"
          labels = {
            "k8s-app" = "kube-dns"
          }
        }
      ]
      subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]

      tags = merge(var.tags, {
        "Name" = "${var.app_name}-fp-coredns"
      })

      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }
    fp-lb-controller = {
      name = "fp-lb-controller"
      selectors = [
        {
          namespace = "kube-system"
          labels = {
            "app.kubernetes.io/name" = "aws-load-balancer-controller"
          }
        }
      ]
      subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]

      tags = merge(var.tags, {
        "Name" = "${var.app_name}-fp-lb-controller"
      })

      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }

    fp-external-dns = {
      name = "fp-external-dns"
      selectors = [
        {
          namespace = "kube-system"
          labels = {
            "app" = "external-dns"
          }
        }
      ]
      subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]

      tags = merge(var.tags, {
        "Name" = "${var.app_name}-external-dns"
      })

      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }

    fp-metrics-server = {
      name = "fp-metrics-server"
      selectors = [
        {
          namespace = "kube-system"
          labels = {
            "k8s-app" = "metrics-server"
          }
        }
      ]
      subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]

      tags = merge(var.tags, {
        "Name" = "${var.app_name}-metrics-server"
      })

      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }

    fp-default = {
      name = "fp-default"
      selectors = [
        {
          namespace = "default"
        }
      ]
      subnet_ids = [module.vpc.private_subnets[1]]

      tags = merge(var.tags, {
        "Name" = "${var.app_name}-default"
      })

      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }
    fp-servian = {
      name = "fp-servian"
      selectors = [
        {
          namespace = "servian"
        }
      ]
      subnet_ids = [module.vpc.private_subnets[1]]

      tags = merge(var.tags, {
        "Name" = "${var.app_name}-servian"
      })

      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }
  }

  tags = var.tags
}
