# @author: Iruka Rupasinghe <irukaavantha@yahoo.com>
# @purpose: Streamline the usage of Terraform to avoid having to run
#		    multiple Terraform commands inside multiple directories.

# export AWS_PROFILE=default
# OR
# export AWS_ACCESS_KEY_ID=
# export AWS_SECRET_ACCESS_KEY=

# export AWS_DEFAULT_REGION=ap-southeast-2
# export ENVIRONMENT=dev

# IN init-s3(s3 bucket named '$(ACCOUNT_ID)-terraform-backend-resources' shall be created)

ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
TF_DIR := $(ROOT_DIR)/cloud/aws/servian/$(ENVIRONMENT)
BACKEND_DIR := $(ROOT_DIR)/init_backend

assert_env:
ifndef ENVIRONMENT
	@echo "Environment value must be provided using |export ENVIRONMENT=" && exit 1
endif

assert_aws_region:
ifndef AWS_DEFAULT_REGION
	@echo "Environment value must be provided using |export AWS_DEFAULT_REGION=" && exit 1
endif

assert_aws_aki:
ifndef AWS_ACCESS_KEY_ID
	@echo "Environment value must be provided using |export AWS_ACCESS_KEY_ID=" && exit 1
endif

assert_aws_sak:
ifndef AWS_SECRET_ACCESS_KEY
	@echo "Environment value must be provided using |export AWS_SECRET_ACCESS_KEY=" && exit 1
endif

assert_aws_s3_bucket:
ifndef AWS_S3_BUCKET
	@echo "Environment value must be provided using |export AWS_S3_BUCKET=" && exit 1
endif

assert_aws_ac_id:
ifndef AWS_ACC_ID
	@echo "Environment value must be provided using |export AWS_ACC_ID=" && exit 1
endif

assert_aws: assert_aws_region assert_aws_aki assert_aws_sak

assert_all: assert_env assert_aws

hello:
	@echo "Test Method. TF_DIR: $(TF_DIR)"
	
clean:
	@echo "Cleaning terraform workspace..."
	@cd "$(TF_DIR)" && rm -rf .terraform

init-s3: assert_aws
	@echo "Creating Terraform backend bucket in AWS S3..."
	@cd "$(BACKEND_DIR)" && terraform init
	@cd "$(BACKEND_DIR)" && terraform plan -out=.terraform/terraform.tfplan
	@cd "$(BACKEND_DIR)" && terraform apply .terraform/terraform.tfplan

init: assert_all
	@echo "Initializing Terraform with S3 backend..."
	@cd "$(TF_DIR)" && terraform get -update=true
	@cd "$(TF_DIR)" && terraform init

deploy-single: assert_all
	@echo "Running Deploy on single TF module only..."
	cd "$(TF_DIR)" && terraform plan -target module.servian-build -var-file="variables/${ENVIRONMENT}.tfvars" -out=.terraform/terraform.tfplan
	cd "$(TF_DIR)" && terraform apply .terraform/terraform.tfplan
	
destroy-single: assert_all
	@echo "Running Destroy on single TF module only..."
	cd "$(TF_DIR)" && terraform plan -target module.servian-build -var-file="variables/${ENVIRONMENT}.tfvars" -out=.terraform/terraform.tfplan -destroy
	cd "$(TF_DIR)" && terraform apply .terraform/terraform.tfplan

deploy: assert_all
	@echo "Building infrastructure and Deploying App on it..."
	@cd "$(TF_DIR)" && terraform plan -var-file="variables/${ENVIRONMENT}.tfvars" -out=.terraform/terraform.tfplan
	@cd "$(TF_DIR)" && terraform apply .terraform/terraform.tfplan

destroy: assert_all
	@echo "Destroying all infrastructure..."
	@cd "$(TF_DIR)" && terraform destroy -var-file="variables/${ENVIRONMENT}.tfvars"
