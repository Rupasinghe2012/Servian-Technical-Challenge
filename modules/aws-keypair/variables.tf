variable "keypair_name" {
  description = "Keypair name"
  type        = string
  default     = "test"
}

variable "tags" {
  type        = map(any)
  description = "AWS tags"
  default     = {}
}
