output "iam_role_name" {
  description = "IAM Role name"
  value       = aws_iam_role.iam_role.name
}

output "iam_instanceprofile_name" {
  description = "IAM Instance Profile name"
  value       = aws_iam_instance_profile.iam_instance_profile.name
}

output "iam_instanceprofile_arn" {
  description = "IAM Instance Profile name"
  value       = aws_iam_instance_profile.iam_instance_profile.arn
}

output "iam_role_arn" {
  description = "IAM Role ARN"
  value       = aws_iam_role.iam_role.arn
}