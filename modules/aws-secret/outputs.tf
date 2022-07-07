output "secret_value" {
  description = "The value of the scret"
  value       = aws_secretsmanager_secret_version.secret_value.secret_string
}
