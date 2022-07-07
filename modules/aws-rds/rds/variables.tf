# VPC settings
variable "vpc_id" {
  description = "VPC ID where RDS is placed"
}

# RDS default AZ
variable "rds_aws_azs" {
  description = "(Optional) The AZ for the RDS instance."
  default     = ""
}

# RDS settings
variable "rds_engine" {
  description = "RDS engine type"
}

variable "rds_port" {
  description = "RDS port"
}

variable "enable_multi_az" {
  description = "Multi AZ"
  type        = bool
  default     = false
}

variable "public_access" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}

variable "ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  default     = "rds-ca-2019"
}

variable "rds_engine_version" {
  description = "Engine Version"
}

variable "rds_storage_encrypted" {
  default = "true"
}

variable "auto_minor_version_upgrade" {
  description = "(Optional) Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  default     = "true"
}

variable "deletion_protection" {
  description = "(Optional) If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to true"
  default     = null
}

# variable "kms_key_id" {
#   description = "KMS ID used to encrypt the RDS"
# }

variable "rds_storage_type" {
  default = "gp2"
}

variable "rds_final_snapshot_identifier" {
  description = "Name of final snapshot Identifier"
}

variable "rds_backup_retention_period" {
  default = 5
}

variable "rds_backup_window" {
  default = "03:00-05:00"
}

variable "enabled_cloudwatch_logs_exports" {
  description = "(Optional) List of log types to enable for exporting to CloudWatch logs"
  type        = list(any)
  default     = []
}

variable "rds_skip_final_snapshot" {
  default = "false"
}

variable "rds_instance_class" {
  description = "Tyoe of Class"
}

variable "rds_defaultdb" {
  description = "Default DB to be created"
  default     = null
}

variable "rds_username" {
  description = "RDS master user name. Default is master."
  default     = "master"
}

variable "rds_instance_identifier" {
  description = "RDS identifier Name"
}

variable "rds_subnet_group_name" {
  description = "Name of RDS subnet group"
}

variable "security_group_ids" {
  description = "ID's of RDS seccurity group"
  type        = list(string)
}

variable "apply_immediately" {
  description = "false: Apply change during next maintenance | true: apply now"
  default     = "false"
}

variable "publicly_accessible" {
  description = "Allow Public access. Default false."
  default     = "false"
}

variable "rds_allocated_storage" {
  description = "storage value for DB"
}

variable "rds_parameter_group_name" {
  description = "Parameter group name to be provided"
}

variable "copy_tags_to_snapshot" {
  description = "(Optional, boolean) Copy all Instance tags to snapshots"
  default     = "false"
}

# Tags
variable "tags" {
  type    = map(any)
  default = {}
}
