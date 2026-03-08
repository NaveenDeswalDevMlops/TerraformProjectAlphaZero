output "ec2_instance_profile_name" {
  value       = aws_iam_instance_profile.ec2.name
  description = "IAM instance profile for EC2"
}

output "lambda_role_arn" {
  value       = aws_iam_role.lambda.arn
  description = "Lambda execution role ARN"
}
