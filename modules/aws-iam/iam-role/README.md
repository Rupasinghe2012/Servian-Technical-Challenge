# IAM-Instance-Role Module

A Terraform module contains the creation of the IAM Instance Role.

## Usage example

```hcl
module "bastian_instance_profile" {
  source = "../../../../modules/aws-infra/aws-iam/iam-role"

  role_name        = "analytics-platform-bastian-node-role"
  description      = "Role to grant permisons for Bastian nodes"
  role_policy_arns = ["${module.bastian_iam_instance_policy.arn}"]
  tags             = local.common_tags
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| role\_name | The IAM Role name | string | - | yes |
| description | The description of the Role | string | "IAM Instance Role" | no |
| role\_path | Whether to forcefully destory the IAM user| string |"/"| no |
| role\_policy\_arns | Whether to Grant AWS Console access | list(string) |"[]"| yes |
| role\_force\_detach\_policies | Specifies to force detaching any policies the role has before destroying it. | bool |"false"| no |
|role\_max\_session\_duration | The maximum session duration (in seconds) that you want to set for the specified role. If you do not specify a value for this setting, the default maximum of one hour is applied. This setting can have a value from 1 hour to 12 hours. | string |"3600"| yes |
| tags | Tag's for the IAM Role | map |"{}"| no |

## Outputs

| Name | Description |
|------|-------------|
| iam\_role\_name | IAM Role name |
| iam\_instanceprofile\_name | IAM Instance Profile name |
| iam\_role\_arn | IAM Role ARN |


## Authors

Created by [Iruka Rupasinghe] 