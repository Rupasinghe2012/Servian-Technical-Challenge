terraform {
  backend "s3" {
    bucket  = "380811051426-terraform-backend-resources"
    key     = "cloud/aws/us-east-1/servian/dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
