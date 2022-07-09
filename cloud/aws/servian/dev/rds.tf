# Postgres RDS Instance --------------------------------------------------------------
module "postgres_rds" {
  source = "../../../../modules/aws-rds/rds"

  rds_allocated_storage         = var.postgres_rds_vars["storage"]
  rds_engine                    = var.postgres_rds_vars["engine"]
  rds_engine_version            = var.postgres_rds_vars["engine_version"]
  auto_minor_version_upgrade    = var.postgres_rds_vars["auto_minor_version_upgrade"]
  rds_instance_class            = var.postgres_rds_vars["instance_class"]
  rds_parameter_group_name      = module.postgres_parameter_group.db_parameter_group_id
  rds_instance_identifier       = var.postgres_rds_vars["instance_identifier"]
  rds_final_snapshot_identifier = var.postgres_rds_vars["final_snapshot_identifier"]
  rds_port                      = var.postgres_rds_vars["port"]
  public_access                 = var.postgres_rds_vars["public_access"]

  rds_defaultdb = var.postgres_rds_vars["defaultdb"]
  rds_username  = var.postgres_rds_vars["username"]

  rds_subnet_group_name = module.vpc.database_subnet_group_name
  vpc_id                = module.vpc.vpc_id
  security_group_ids    = [module.postgre_rds_sg.sg_id]
  enable_multi_az       = var.postgres_rds_vars["enable_multi_az"]
  ca_cert_identifier    = var.postgres_rds_vars["ca_cert_identifier"]

  tags = var.tags
}

# PostgreSQL RDS Parameter Group  ---------------------------------------------------
module "postgres_parameter_group" {
  source = "../../../../modules/aws-rds/parameter-group"

  identifier       = var.postgres_rds_vars["instance_identifier"]
  description      = var.postgres_rds_vars["pg_description"]
  param_group_name = var.postgres_rds_vars["pg_name"]
  rds_family       = var.postgres_rds_vars["pg_rds_family"]

  parameters = [{
    apply_method = "pending-reboot"
    name         = "max_connections"
    value        = "100"
  }]

  tags = merge(var.tags, {
    Name = var.postgres_rds_vars["pg_name"]
  })
}
