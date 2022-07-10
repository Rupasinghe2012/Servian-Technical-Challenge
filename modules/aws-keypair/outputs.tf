output "key_name" {
  description = "The name of the keypair"
  value       = aws_key_pair.key_pair.key_name
}

output "private_key" {
  value = module.private_key_pem.secret_value
}
