variable "bucket_name" {
  type        = string
  description = "Required: The name for your S3 bucket to house Terraform state files"
}

variable "dynamodb_state_locking" {
  type        = bool
  description = "Optional: Creates a DynamoDB table to lock state. Defaults to false."
  default     = false
}

variable "dynamodb_table_name" {
  type        = string
  description = "Reqiured if dynamodb_state_locking set to true: The DynamoDB table name to create if using state locking"
  default     = null
}

variable "s3_kms_arn" {
  type        = string
  description = "Optional: The default KMS key's ARN to use to encrypt objects in the S3 bucket. If not set, defaults to use AWS owned S3 encryption key."
  default     = null
}

variable "s3_tags" {
  type        = map(any)
  description = "Optional: The tags to add to your S3 bucket"
  default     = null
}

variable "dynamodb_tags" {
  type        = map(any)
  description = "Optional: The tags to add to your DynamoDB table"
  default     = null
}

variable "dynamodb_managed_kms" {
  type        = bool
  description = "Optional: If set to true, uses AWS Managed CMK. If set to false, uses AWS Owned CMK. Defaults to false."
  default     = false
}

variable "block_tfstate_at_root" {
  type        = bool
  description = "Optional: When true, prevents an object named terraform.tfstate at the root of your bucket. Prevents workspaced configurations from accidentally applying to default workspace."
  default     = false
}
