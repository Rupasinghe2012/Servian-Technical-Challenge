variable "keypair_name" {
  description = "Keypair name"
  type        = string
  default     = ""
}

variable "public_keypair" {
  description = "Public key of the created keypair"
  type        = string
  default     = "IAM Policy"
}
