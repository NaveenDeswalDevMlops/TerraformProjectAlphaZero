# Environment wrapper: keeps environment-specific values isolated from reusable modules.
module "private_aws" {
  source = "../../"

  region               = var.region
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  private_subnet_cidrs = var.private_subnet_cidrs
  instance_type        = var.instance_type
  bucket_name          = var.bucket_name
  input_prefix         = var.input_prefix
  output_prefix        = var.output_prefix
  tags                 = var.tags
}

output "vpc_id" {
  value = module.private_aws.vpc_id
}

output "private_subnet_ids" {
  value = module.private_aws.private_subnet_ids
}

output "s3_bucket_name" {
  value = module.private_aws.s3_bucket_name
}

output "lambda_arn" {
  value = module.private_aws.lambda_arn
}
