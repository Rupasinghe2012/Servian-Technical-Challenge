resource "aws_db_instance" "rds" {
  allocated_storage          = var.rds_allocated_storage
  storage_type               = var.rds_storage_type
  engine                     = var.rds_engine
  engine_version             = var.rds_engine_version
  instance_class             = var.rds_instance_class
  identifier                 = var.rds_instance_identifier
  parameter_group_name       = var.rds_parameter_group_name
  port                       = var.rds_port
  ca_cert_identifier         = var.ca_cert_identifier
  multi_az                   = var.enable_multi_az
  publicly_accessible        = var.public_access
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  deletion_protection        = var.deletion_protection

  storage_encrypted               = var.rds_storage_encrypted
  backup_retention_period         = var.rds_backup_retention_period
  final_snapshot_identifier       = var.rds_final_snapshot_identifier
  backup_window                   = var.rds_backup_window
  skip_final_snapshot             = var.rds_skip_final_snapshot
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  copy_tags_to_snapshot           = var.copy_tags_to_snapshot

  db_name  = var.rds_defaultdb
  username = var.rds_username
  password = random_password.db_master_pass.result

  db_subnet_group_name   = var.rds_subnet_group_name
  availability_zone      = var.rds_aws_azs
  vpc_security_group_ids = var.security_group_ids

  tags = merge(var.tags, tomap({ "Name" = var.rds_instance_identifier }))
}

resource "random_password" "db_master_pass" {
  length           = 16
  special          = true
  override_special = "!#$^&?"
}

module "db_master_pass" {
  source = "../../aws-secret/"

  secret_name  = "${var.rds_instance_identifier}-rds-passwords"
  secret_value = random_password.db_master_pass.result

  tags = merge(var.tags, {
    Name = "${var.rds_instance_identifier}-rds-passwords"
  })
}
