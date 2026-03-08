output "s3_endpoint_id" {
  value       = aws_vpc_endpoint.s3.id
  description = "Gateway endpoint ID for S3"
}

output "logs_endpoint_id" {
  value       = aws_vpc_endpoint.logs.id
  description = "Interface endpoint ID for CloudWatch Logs"
}
