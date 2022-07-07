variable "sg_name" {
  type        = string
  description = "Name of the Security Group"
  default     = ""
}

variable "sg_description" {
  type        = string
  description = "Name of the Security Group"
  default     = ""
}

variable "application_name" {
  type        = string
  description = "Name of the application"
}

variable "environment" {
  type        = string
  description = "Environment to which the infrastructure belongs"
}

variable "role" {
  type        = string
  description = "Role of the security group; such as instance, elb, db, efs, nfs, mgmt"
  default     = "instance"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID of the VPC in which the SG will be created"
}

/*
 * A sample list of security group rules with CIDRs:-
 *      rules_with_cidr_as_source = [
 *              {
 *                      rule_type: "ingress",
 *                      from_port: "443",
 *                      to_port: "443",
 *                      protocol: "tcp",
 *                      source: ["10.0.0.0/24"]
 *              }
 *      ]
 */
variable "rules_with_cidr_as_source" {
  type        = list(any)
  description = "List of maps where each map represent a security group rule with its source as another security group. Each elemental map should contain rule_type from_port, to_port, protocol, source"
  default     = []
}

/*
 * A sample list of security group rules with CIDRs:-
 *      rules_with_cidr_as_source = [
 *              {
 *                      rule_type: "ingress",
 *                      from_port: "443",
 *                      to_port: "443",
 *                      protocol: "tcp",
 *                      source: module.lb_sg.security_group_id
 *              }
 *      ]
 */
variable "rules_with_security_group_as_source" {
  type        = list(any)
  description = "List of maps where each map represent a security group rule with its source as another security group. Each elemental map should contain rule_type from_port, to_port, protocol, source"
  default     = []
}

variable "tags" {
  type        = map(any)
  description = "AWS tags"
  default     = {}
}