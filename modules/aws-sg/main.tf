/*
 * Creates a security group with dynamic rules from both CIDR blocks and other security groups' IDs.
 * Security group rules can be passed as a list of maps where each map represents a single rule.
 * Rules with CIDR blocks as the source are contained within a single list while rules with security groups' IDs are
 * containd within another list.
 *
 * A sample list of security group rules with CIDRs:-
 *      rules_with_cidr_as_source = [
 *              {
 *                      rule_type: "ingress",
 *                      from_port: "443",
 *                      to_port: "443",
 *                      protocol "tcp",
 *                      cidrs: ["10.0.0.0/24"]
 *              }
 *      ]
 */

# Security Group.
resource "aws_security_group" "security_group" {

  name        = (var.sg_name == "" ? lower("${var.application_name}-${var.environment}-${var.role}-sg") : var.sg_name)
  description = (var.sg_description == "" ? "Security group for ${var.application_name} ${var.role} in ${var.environment}" : var.sg_description)
  vpc_id      = var.vpc_id

  tags = merge(var.tags, tomap({ "Name" = lower("${var.application_name}-${var.environment}-${var.role}-sg") }))
}

# Attach CIDR based rules to security group.
resource "aws_security_group_rule" "security_group_rule_cidr" {
  count = length(var.rules_with_cidr_as_source)

  type              = lookup(var.rules_with_cidr_as_source[count.index], "rule_type")
  from_port         = lookup(var.rules_with_cidr_as_source[count.index], "from_port")
  to_port           = lookup(var.rules_with_cidr_as_source[count.index], "to_port")
  protocol          = lookup(var.rules_with_cidr_as_source[count.index], "protocol")
  cidr_blocks       = lookup(var.rules_with_cidr_as_source[count.index], "source")
  description       = lookup(var.rules_with_cidr_as_source[count.index], "description", "Add description in your tf script")
  security_group_id = aws_security_group.security_group.id

  depends_on = [
  aws_security_group.security_group]
}

# Attach security group id based rules to security group.
resource "aws_security_group_rule" "security_group_rule_source" {
  count = length(var.rules_with_security_group_as_source)

  type                     = lookup(var.rules_with_security_group_as_source[count.index], "rule_type")
  from_port                = lookup(var.rules_with_security_group_as_source[count.index], "from_port")
  to_port                  = lookup(var.rules_with_security_group_as_source[count.index], "to_port")
  protocol                 = lookup(var.rules_with_security_group_as_source[count.index], "protocol")
  source_security_group_id = lookup(var.rules_with_security_group_as_source[count.index], "source")
  description              = lookup(var.rules_with_security_group_as_source[count.index], "description", "Add description in your tf script")
  security_group_id        = aws_security_group.security_group.id

  depends_on = [
  aws_security_group.security_group]
}

resource "aws_security_group_rule" "allow_all_internal" {
  type              = "ingress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.security_group.id
  description       = "allow all internal traffic - self"
}
