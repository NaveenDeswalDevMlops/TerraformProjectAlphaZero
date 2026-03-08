output "instance_id" {
  value       = aws_instance.this.id
  description = "Private EC2 instance ID"
}

output "security_group_id" {
  value       = aws_security_group.ec2.id
  description = "EC2 security group ID"
}
