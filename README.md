# Servian-Technical-Challenge

[![Release][release-badge]][release]
[![License][license-badge]][license]

[release-badge]: https://img.shields.io/github/release/Rupasinghe2012/Servian-Technical-Challenge/all.svg?style=flat&color=brightgreen
[release]:https://github.com/Rupasinghe2012/Servian-Technical-Challenge/releases
[license-badge]: https://img.shields.io/github/license/Rupasinghe2012/Servian-Technical-Challenge.svg?style=flat&color=lightgrey
[license]: https://github.com/Rupasinghe2012/Servian-Technical-Challenge/license

Introduction
-------------------------------
This is the Servian Tech challenge solution code repository to build and deploy Servian's TechChallengeApp to AWS Cloud infrastructure while adhering to following guidelines. 

### **Prerequisites**
* AWS IAM Account with Priviledged access for following services
  * EC2, EKS, ELB, S3, SecretManager, RDS, IAM, etc.
* AWS CLI
* Terraform Core installed ( v1.0.4 or higher)
* Makefile runtime (Ability to run Makefile)
* CLI Utilities: , etc.* Network reachability to "http://ipv4.icanhazip.com" (in evaluating public IP of Terraform Core workstation for whitelisting)


## Architecture
* Architecture Design Records (ADR) are recorded in  [DesignRecords.md](DesignRecords.md) - this file.
* **Decision Process FlowChart.** (More details in [DesignRecords.md#5-finalize-design-decisions--network--resiliency](DesignRecords.md))
![Decision Process FlowChart](https://drive.google.com/uc?export=view&id=1Ugzge6ZIIzo1m-3M3U8dK_eXR0idpZtG)
* **Architecture Diagram.** (More details in [DesignRecords.md#6-finalize-architecture](DesignRecords.md))
![Architecture Diagram](https://drive.google.com/uc?export=view&id=1iB-qRM_9H5mor512dWjh_NStXq4KQaYP)

## Directory Structure
| Directory                | Purpose/Description                                                                                                                                              |
|--------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [cloud](./cloud) | Contains Terraform configuaration needed to spinup the infrastructure on which TechChallengeApp will be deplyed on.                                                      |
| [modules](./modules)     | Contains AWS Terraform modules and helm charts needed to spinup infrastrcture                                                                                    |
| [init_backend](./init_backend)     | Contains the configurations for Terraform state bucket creation                                                                                        |
| [docs](./docs)  | Contains the document related to the solution.                                                                  |

## Process and Instructions - Infrastructure Creation and Configuration

### Requirements to define a new environment

Requirements to create a new environment are:
- Create an S3 bucket to store data and terraform states.

Remember to create files under relavent environment folder "cloud/aws/servian/#ENV#/".
According to the environment you only needed to create a ${ENV}.tfvar file under this folder "cloud/aws/servian/#ENV#/variables/"

Ex: 
-  dev.tfvars

Note: Here environment is considered as dev.

### Common steps

To configure the infrastructure it is necessary to declare the environment variables:

```bash
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_DEFAULT_REGION=ap-southeast-2
export ENVIRONMENT=dev
```

### Steps to follow "if Make file process is chosen?"
**0. Create Backend Terrafform State S3 Bucket**
* With make file, you are given with facility of simply creating a S3 bucket for Terraform state as follows ${ACCOUNT_ID}-terraform-backend-resources

```bash
make init-s3
```

**1. Update dependancies**
```bash
make init
```

**2. Deploy of infrastructure**
```bash
make deploy
```

**3. Destroy of infrastructure**
```bash
make destroy
```

### Steps to follow "if Terraform command process is chosen?"
**0. Create S3 Bucket**
```bash
cd init_backend
terraform init
terraform apply
```

**1. Update dependancies**

To update the dependencies and start the project execution, it is necessary to perform the following steps:

```bash
cd cloud/aws/servian/${ENVIRONMENT}
rm -rf .terraform
terraform get -update=true
terraform init
```
**Note:** This step must always be done before deploying or destroying the infrastructure.

**2. Deploy of infrastructure**


```bash
cd cloud/aws/servian/${ENVIRONMENT}
terraform plan -var-file="variables/${ENVIRONMENT}.tfvars" -out=.terraform/terraform.tfplan
terraform apply .terraform/terraform.tfplan
```

**3. Destroy of infrastructure**

```bash
cd cloud/aws/servian/${ENVIRONMENT}
terraform destroy -var-file="variables/${ENVIRONMENT}.tfvars"
```
### DEMO

(More details on Accessing the actually deployed Servian Tech Challenge APP and screenshots can be found in [Demo](docs/demo/README.md))

My(Iruka's) Work Breakdown
-------------------------------
**Todo**
**Done**
- [x] Used proper Git workflow: [Gitflow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)
- [X] Prepared the Architechture diagram and Decis.
- [X] Security (Network segmentation (if applicable to the implementation), Secret storage, Platform security features)
- [X] Resiliency (Auto scaling and highly available frontend, Highly available Database)
- [X] Prepared process instructions for provisioning my solution.

**Noticed**
* If you are setting up the database using RDS, do not run the ./TechChallengeApp updatedb command. Instead run ./TechChallengeApp updatedb -s

**Limitations**
* Though HTTPS with TLS is used, CA Signed certificate could not be used. (instead aself-signed certificate was used)
  * Lets Encrypt - ACME is not supported in AWS ALB ingress controller
  * While Nginx Ingress controller supports ACME, AWS Fargate does not support Nginx ingress controller
  * While AWS Certificate Manager offers free CA signed certificates, could not obtain due to not havein dedicated DNS for the app.
*  Though external-dns is installed its not used due to not having dedicated DNS for the App.

**Suggested Improvements**
* Attaching AWS WAF to the AWS ALB. (For enhanced security if the APP is growing)
* Implement a CI solution for Terraform infrastructure creation via GitHub Workflow or GitlabCI
* Implement a gitops based CD model by using ArgoCD or Flux
* Integrate AWS Secret manager directly to EKS environment via external-secrets.
* Implement proper log monitoring and management stack ( Elasticsearch / Logstash / Kibana )
* Integrate with Performance monitoring platform ( Grafana / Prometheus)
