variable "policy_name" {
  description = "The name of the policy"
  type        = string
}

variable "description" {
  description = "The description of the policy"
  type        = string
  default     = "IAM Policy"
}

variable "policy_template" {
  description = "The JSON template of the policy in JSON file"
  type        = string
}

variable "tags" {
  type = map
  default = {
  }
}
