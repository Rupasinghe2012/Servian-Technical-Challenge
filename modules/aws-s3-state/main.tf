resource "aws_s3_bucket" "tf_state" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.bucket_name}"
  acl    = "private"
  tags   = var.s3_tags

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        // If KMS is set to null, use default AWS S3 Key
        sse_algorithm = var.s3_kms_arn == null ? "AES256" : "aws:kms"
        // If null, not used
        kms_master_key_id = var.s3_kms_arn
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket              = aws_s3_bucket.tf_state.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
}

resource "aws_dynamodb_table" "dynamodb_state_locking" {
  //If state_locking set to true, set count to 1, enabling the resource
  count = var.dynamodb_state_locking == true ? 1 : 0

  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  //If dynamodb_kms set to true, use AWS Managed encryption key. If false, use AWS owned key
  //See https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/EncryptionAtRest.html
  server_side_encryption {
    enabled = var.dynamodb_managed_kms == true ? true : false
  }

  tags = var.dynamodb_tags
}

# This bucket policy prevents the upload of a terraform.tfstate file at the root of the bucket
# Prevents users from applying changes in the default workspace, whose key is terraform.tfstate
resource "aws_s3_bucket_policy" "root_terraform_state_block" {
  count  = var.block_tfstate_at_root ? 1 : 0
  bucket = aws_s3_bucket.tf_state.id

  policy = data.aws_iam_policy_document.block_root_state.json
}
