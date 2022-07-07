output "s3-bucket" {
  value = aws_s3_bucket.tf_state
}

output "dynamo-table" {
  value = aws_dynamodb_table.dynamodb_state_locking
}
