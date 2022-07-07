# AWS Security Group Terraform module

Terraform module which creates security Groups.

## Usage

```hcl
module "security_group" {
  source = "./tf_aws_security_group"

  application_name = var.application_name
  environment = var.environment
  role = "instance"
  
  rules_with_cidr_as_source = [
    {
      rule_type: "egress",
      from_port: "0",
      to_port: "65535",
      protocol: "-1",
      source: [
        "0.0.0.0/0"]
      description: "Allow all outbound traffic"
    }
  ]

  rules_with_security_group_as_source = [
    {
      rule_type: "ingress",
      from_port: "80",
      to_port: "80",
      protocol: "tcp",
      source: module.some_other_security_group.security_group_id
      description: "HTTP requests from Load Balancer"
    },
    {
      rule_type: "ingress",
      from_port: "22",
      to_port: "22",
      protocol: "tcp",
      source: data.terraform_remote_state.some_other_layer.outputs.some_other_security_group_id
      description: "SSH access"
    }
  ]
  
  vpc_id = data.terraform_remote_state.some_other_layer.outputs.vpc_id
  tags = var.common_tags
}

```


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| application_name | Name of the application| string | `-` | yes |
| environment | Environment to which the infrastructure belongs | string | `-` | yes |
| role | Role of the security group; such as instance, elb, db, efs, nfs, mgmt| string | `"es-instance"` | no |
| vpc_id | VPC ID of the VPC in which the SG will be created| string | `-` | yes |
| rules_with_cidr_as_source | List of maps where each map represent a security group rule with its source as another security group. Each elemental map should contain rule_type from_port, to_port, protocol, source | list | `` | no |
| rules_with_security_group_as_source | List of maps where each map represent a security group rule with its source as another security group. Each elemental map should contain rule_type from_port, to_port, protocol, source | list | `` | no |
| tags | AWS tags| map | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| sg\_id | The ID of the Security Group |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by Iruka Rupasinghe
## License

Apache 2 Licensed. See LICENSE for full details.
