variable "role_name" {
  description = "The IAM Role name"
  type        = string
}

variable "description" {
  description = "The description of the Role"
  type        = string
  default     = "IAM Instance Role"
}

variable "max_session_duration" {
  description = "he maximum session duration (in seconds) that you want to set for the specified role. If you do not specify a value for this setting, the default maximum of one hour is applied. This setting can have a value from 1 hour to 12 hours."
  type        = string
  default     = 3600
}

variable "assume_role_policy" {
  description = "Assume role policy Document"
  type        = string
  default     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

variable "role_path" {
  description = "The path to the role. See https://docs.aws.amazon.com/IAM/latest/UserGuide/Using_Identifiers.html for more information."
  type        = string
  default     = "/"
}

variable "role_policy_arns" {
  description = "IAM policy ARN to be attached to the role"
  type        = list(string)
  default     = []
}

variable "role_force_detach_policies" {
  description = "Specifies to force detaching any policies the role has before destroying it."
  default     = false
  type        = bool
}

variable "role_max_session_duration" {
  description = "The maximum session duration (in seconds) that you want to set for the specified role. If you do not specify a value for this setting, the default maximum of one hour is applied. This setting can have a value from 1 hour to 12 hours."
  default     = 3600
}

variable "tags" {
  type = map
  default = {
    Terraform   = "true"
    AppID       = ""
    AppName     = ""
    GroupOwner  = ""
    environment = ""
  }
}