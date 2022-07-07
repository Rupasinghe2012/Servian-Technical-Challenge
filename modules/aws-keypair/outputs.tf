output "key_name" {
  description = "The name of the keypair"
  value       = aws_key_pair.key_pair.key_name
}
