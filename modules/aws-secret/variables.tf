variable "secret_name" {
  description = "Name of the Secret"
  type        = string
}

variable "secret_value" {
  description = "Secret Values"
  default     = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}