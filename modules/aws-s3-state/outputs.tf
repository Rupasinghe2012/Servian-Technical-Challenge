output "s3-bucket" {
  value = aws_s3_bucket.tf_state
}

output "s3-bucket-name" {
  value = aws_s3_bucket.tf_state.bucket
}

output "dynamo-table" {
  value = aws_dynamodb_table.dynamodb_state_locking
}
