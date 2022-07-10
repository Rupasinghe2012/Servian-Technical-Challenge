output "rds_instance_endpoint" {
  description = "RDS Endpoint"
  value       = aws_db_instance.rds.endpoint
}

output "rds_instance_address" {
  description = "RDS Endpoint"
  value       = aws_db_instance.rds.address
}

output "rds_username" {
  description = "The master username for the database."
  value       = aws_db_instance.rds.username
}

output "rds_password" {
  description = "The master password for the database."
  value       = module.db_master_pass.secret_value
}
