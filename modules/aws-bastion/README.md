# AWS Bastian Terraform module

Terraform module which creates bastian server on AWS inside the VPC.

## Usage

```hcl
module "bastian_server" {
  source = "../../../../modules/aws-bastian"

  app_name = "test"

  ## Lauch Configurations
  worker_public_ip_enabled = false
  ami_id = local.ami_id_linux
  instance_type = "t2.medium"
  instance_security_groups = [module.bastian_sg.sg_id]
  instance_keypair = module.keypair.key_name
  block_volume_size = 50
  block_delete_on_termination = true

  ## AutoScaling Group
  asg_desired_capacity = 1
  asg_max_size = 1
  asg_min_size = 1
  subnet_ids = module.prod_vpc.private_subnets
  
  tags = local.common_tags
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| tags | List of tags | map | `{}` | yes |
| application_name | Application name for the tags | string | `""` | yes |
| bastion_public_ip_enabled | Associate a public ip address with an instance in a VPC | string | `"true"` | no |
| iam_instance_profile | The IAM Instance Profile to launch the instance with | string | `""` | yes |
| ami_id | The AMI to use for the instance | string | `"ami-098f49793dc110d98"` | yes |
| instance_type | The type of instance to start | string | `"t2.medium"` | yes |
| instance_security_groups | A list of security group names | list | `""` | yes |
| instance_keypair | The key name of the Key Pair to use for the instance | string | `"AWS-DAI-NONPROD"` | yes |
| subnet_ids | list of subnet IDs | list | `""` | yes |
| block_volume_size | The size of the volume in gibibytes | string | `"300"` | yes |
| block_delete_on_termination | Whether the volume should be destroyed on instance termination | string | `"true"` | yes |
| asg_desired_capacity | The number of Amazon EC2 instances that should be running in the group | string | `"3"` | yes |
| asg_max_size | The maximum size of the auto scale group | string | `"5"` | yes |
| asg_min_size | The minimum size of the auto scale group | string | `"3"` | yes |
| iam_role_arn | IAM role arn of the bastian | string | `""` | yes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by Iruka Rupasinghe
