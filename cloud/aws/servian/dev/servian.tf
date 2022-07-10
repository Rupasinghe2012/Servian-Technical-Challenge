# # Connect in to Bastion, configure k8s ALB ingress controller, deploy servian app to k8s, configure k8s horizontal pod autoscaler
module "servian-build" {
  source = "../../../../modules/servian-build"

  short_name          = var.app_name
  region              = var.aws_region
  bastion_name        = module.bastion.name
  bastion_private_key = module.key-pair.private_key

  domain_name = var.domain_name

  vpc_id                              = module.vpc.vpc_id
  eks_cluster_name                    = module.eks.cluster_id
  eks_node_role_arn                   = module.bastion_role.iam_role_arn
  eks_fargate_role_arn                = module.fargate_profile_role.iam_role_arn
  eks_external_dns_role_arn           = module.external_dns_role.iam_role_arn
  eks_lb_controller_role_arn          = module.lb_controller_role.iam_role_arn
  eks_arn_user_list_with_masters_user = var.eks_arn_user_list

  eks_alb_ing_ssl_cert_arn = module.alb_self_signed_certificate.self_ssl_cert_arn
  app_backend_db_host      = module.postgres_rds.rds_instance_address
  app_backend_db_user      = module.postgres_rds.rds_username
  app_backend_db_password  = module.postgres_rds.rds_password
}
