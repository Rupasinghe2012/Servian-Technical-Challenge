resource "aws_iam_role" "iam_role" {
  name        = var.role_name
  description = var.description
  tags        = var.tags

  assume_role_policy   = var.assume_role_policy
  max_session_duration = var.max_session_duration
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "${var.role_name}-instance-profile"
  role = aws_iam_role.iam_role.name
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  count      = length(var.role_policy_arns)
  role       = aws_iam_role.iam_role.name
  policy_arn = var.role_policy_arns[count.index]
}
