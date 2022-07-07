variable "param_group_name" {
  description = "(Optional, Forces new resource) The name of the DB parameter group. If omitted, Terraform will assign a random, unique name"
  default     = ""
}

variable "rds_family" {
  description = "Required) The family of the DB parameter group."
}

variable "description" {
  description = "The description of the DB parameter group"
  type        = string
  default     = ""
}

variable "identifier" {
  description = "The identifier of the resource"
  type        = string
}

variable "parameters" {
  description = "A list of DB parameter maps to apply"
  type        = list(map(string))
  default     = []
}

# Tags
variable "tags" {
  type    = map(any)
  default = {}
}
