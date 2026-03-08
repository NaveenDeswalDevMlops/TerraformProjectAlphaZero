# terraform-private-aws

A modular Terraform project that provisions a **private AWS infrastructure** with:

- A custom VPC with two private subnets in separate AZs
- No public subnets, Internet Gateway, or NAT Gateway
- One private EC2 instance with IAM role for S3 read access
- One private S3 bucket configured to trigger Lambda on object uploads
- One Lambda function that reads uploaded objects and writes processed output to another prefix
- VPC endpoints for S3 (Gateway) and CloudWatch Logs (Interface)

## Structure

```text
terraform-private-aws/
  modules/
    vpc/
    ec2/
    lambda/
    s3/
    iam/
    endpoints/
  environments/
    dev/
      main.tf
      variables.tf
      terraform.tfvars
  lambda_src/
    handler.py
  main.tf
  variables.tf
  versions.tf
  providers.tf
  outputs.tf
```

## Usage

```bash
cd terraform-private-aws/environments/dev
terraform init
terraform plan
terraform apply
```

> Ensure `bucket_name` in `terraform.tfvars` is globally unique.
