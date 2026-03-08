data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  selected_azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "vpc" {
  source = "./modules/vpc"

  name                = var.project_name
  vpc_cidr            = var.vpc_cidr
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones  = local.selected_azs
  tags                = var.tags
}

module "iam" {
  source = "./modules/iam"

  name        = var.project_name
  bucket_name = var.bucket_name
  tags        = var.tags
}

module "lambda" {
  source = "./modules/lambda"

  name          = var.project_name
  source_file   = "${path.module}/lambda_src/handler.py"
  role_arn      = module.iam.lambda_role_arn
  output_prefix = var.output_prefix
  tags          = var.tags
}

module "s3" {
  source = "./modules/s3"

  bucket_name          = var.bucket_name
  lambda_function_arn  = module.lambda.lambda_arn
  lambda_function_name = module.lambda.lambda_name
  input_prefix         = var.input_prefix
  tags                 = var.tags
}

module "ec2" {
  source = "./modules/ec2"

  name                      = var.project_name
  vpc_id                    = module.vpc.vpc_id
  vpc_cidr                  = var.vpc_cidr
  subnet_id                 = module.vpc.private_subnet_ids[0]
  instance_type             = var.instance_type
  iam_instance_profile_name = module.iam.ec2_instance_profile_name
  tags                      = var.tags
}

module "endpoints" {
  source = "./modules/endpoints"

  name                   = var.project_name
  region                 = var.region
  vpc_id                 = module.vpc.vpc_id
  private_route_table_id = module.vpc.private_route_table_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  private_subnet_cidrs   = var.private_subnet_cidrs
  tags                   = var.tags
}
