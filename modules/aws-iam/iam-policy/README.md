# IAM-Policy Module

A Terraform module contains the creation of the IAM Policy

## Usage example

```hcl
module "dev_k8s_policy" {
  source = "../../../modules/aws-infra/aws-iam/iam-policy"

  policy_name        = "dai-dev-k8s"
  description = "Group Policy for DAI Dev"
  policy_path    = "${file("policies/dai_dev_policy.json.tpl")}"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| policy\_name | The name of the policy | string | - | yes |
| description | The description of the policy | string | "IAM Policy" | no |
| policy\_path | The path of the policy in JSON file | list(string) |""| yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The policy's ID |
| arn | The ARN assigned by AWS to this policy |
| description | The description of the policy |
| name | The name of the policy |
| path | The path of the policy in IAM |
| policy | The policy document |

## Authors

Created by [Iruka Rupasinghe] 
