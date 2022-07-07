# Terraform State Management via S3
This module helps to create the resources needed for state management via AWS S3 buckets. Also, the module optionally creates a DynamoDB table for state locking and consistency. It is recommended to use DynamoDB for state locking when working with large team sizes, or automating Terraform plans/applies.

Unless you are using a different backend configuration, you will need to store your state locally for the execution of this module. You may later migrate the state data to  resources created by this module.

## Using the Module
This module should be called using the following configuration:

    module "s3-state" {
      source = "./aws-s3-state

      bucket_name = "123456789-terraform-state"
    }

The above example is the required minimum configuration for creating an S3 bucket for use as a Terraform backend. Bucket will be created as ${ACCOUNT_ID}-bucket-name.

### Required Variables
- `bucket_name` (string): The name of the AWS S3 bucket to create

### Optional Variables
 - `dynamodb_state_locking` (bool): If set to true, creates a DynamoDB table to control state locking and consistency. Defaults to false.
   - `dynamodb_table_name` (string): Required if `dynamodb_state_locking` is set to true. Sets the name for the DynamoDB table to be created.
   - `dynamodb_tags` (map): An optional set of key/value tags to set on the DynamoDB table.
   - `dynamodb_managed_kms` (bool): If set to true, uses the AWS managed customer master keys (CMK) rather than the AWS owned CMK. Defaults to false. [See this link for more information on AWS managed vs owned CMK with KMS.](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/EncryptionAtRest.html)
 - `s3_tags` (map): An optional set of key/value tags to set on the S3 bucket.
 - `s3_kms_arn` (string): The ARN of the KMS key to use as the default encryption key. If unset, uses the AWS owned key and AES256 encryption.
 - `block_tfstate_at_root` (bool): If set to true, prevents an object named terraform.tfstate at the root of your bucket. Prevents workspaced configurations from accidentally applying to default workspace. Defaults to false.

## Default Resource Configurations
For S3, the following settings are enabled:
 - Restrict public access to the bucket
 - Enforce encryption for objects in the bucket
 - Bucket ACL is set to private

For DynamoDB, the following settings are enabled:
 - Table capacity is on-demand
 - Point-in-time recovery is enabled
 - Hash key is `LockID`
 - Default encryption is AWS owned CMK. AWS managed CMK configurable via variables.