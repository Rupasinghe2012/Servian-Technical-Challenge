resource "aws_secretsmanager_secret" "secret_key" {
  name = var.secret_name

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "secret_value" {
  secret_id     = aws_secretsmanager_secret.secret_key.id
  secret_string = var.secret_value
}