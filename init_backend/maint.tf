# S3 Bucket for Terraform Backend ---------------------
module "s3-backend" {
  source = "../modules/aws-s3-state/"

  bucket_name = "terraform-backend-resources"
}
