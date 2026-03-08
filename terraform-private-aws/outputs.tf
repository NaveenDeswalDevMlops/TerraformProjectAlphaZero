output "vpc_id" {
  description = "ID of the private VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}

output "s3_bucket_name" {
  description = "Name of the private S3 bucket"
  value       = module.s3.bucket_name
}

output "lambda_arn" {
  description = "ARN of S3 processing Lambda"
  value       = module.lambda.lambda_arn
}
