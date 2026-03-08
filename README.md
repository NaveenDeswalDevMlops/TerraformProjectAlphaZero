# Private AWS Infrastructure with Terraform

## Project Overview

This project provisions a fully private AWS environment using Terraform. It demonstrates how to build cloud infrastructure that operates without public internet exposure while still enabling controlled access to required AWS managed services.

The design focuses on security-first networking and service-to-service communication through VPC endpoints.

## Architecture Description

The infrastructure is built around a custom VPC with two private subnets in separate Availability Zones for high availability and fault tolerance. There are no public subnets, no Internet Gateway, and no NAT Gateway.

Within this private network:

- An EC2 instance runs inside a private subnet.
- A private S3 bucket stores inbound and processed objects.
- A Lambda function is triggered by S3 object uploads.
- IAM roles and policies provide least-privilege access for EC2 and Lambda.
- VPC endpoints provide private connectivity to AWS services:
  - S3 Gateway Endpoint
  - CloudWatch Logs Interface Endpoint

### Functional Flow

1. A file is uploaded to the private S3 bucket (for example, under `input/`).
2. S3 triggers the Lambda function.
3. Lambda processes the object and writes the result to another prefix (for example, `output/`).
4. The private EC2 instance can read and write to S3 using the S3 VPC endpoint.
5. Lambda logs are delivered privately through the CloudWatch Logs VPC endpoint.

## Architecture Diagram (ASCII)

```text
                         AWS Region
┌────────────────────────────────────────────────────────────────┐
│                          Custom VPC                           │
│                                                                │
│  ┌────────────────────────┐     ┌────────────────────────┐     │
│  │ Private Subnet (AZ-a)  │     │ Private Subnet (AZ-b)  │     │
│  │                        │     │                        │     │
│  │  EC2 Instance          │     │  Lambda Function       │     │
│  │  (no public IP)        │     │  (private execution)   │     │
│  └────────────┬───────────┘     └────────────┬───────────┘     │
│               │                              │                 │
│               └──────────────┬───────────────┘                 │
│                              │                                 │
│                 VPC Endpoints (Private Access)                 │
│                 - S3 Gateway Endpoint                          │
│                 - CloudWatch Logs Endpoint                     │
│                              │                                 │
│                       ┌──────▼─────────┐                       │
│                       │ Private S3     │                       │
│                       │ Bucket         │                       │
│                       │ input/         │                       │
│                       │ output/        │                       │
│                       └──────┬─────────┘                       │
│                              │                                 │
│                     S3 Event Notification                      │
│                              │                                 │
│                        ┌─────▼─────┐                           │
│                        │  Lambda   │                           │
│                        │ Processing│                           │
│                        └───────────┘                           │
│                                                                │
│  No Public Subnets | No Internet Gateway | No NAT Gateway      │
└────────────────────────────────────────────────────────────────┘
```

## Folder Structure

```text
.
├── README.md
├── providers.tf
├── variables.tf
├── main.tf
├── outputs.tf
├── versions.tf
├── modules/
│   ├── network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── compute/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── storage/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── lambda/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── iam/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── lambda_src/
    └── handler.py
```

## Terraform Modules Explanation

### `network` module
Responsible for all networking components:

- Custom VPC
- Two private subnets in different AZs
- Route tables for private-only traffic
- Security groups permitting only internal communication
- S3 Gateway VPC endpoint
- CloudWatch Logs Interface VPC endpoint

### `compute` module
Deploys the private EC2 instance:

- EC2 in a private subnet
- No public IP assignment
- Security group attached for internal-only access
- IAM instance profile for S3 access via endpoint

### `storage` module
Creates and configures S3:

- Private S3 bucket (block public access)
- Bucket policy aligned with private access requirements
- Prefix structure for `input/` and `output/`
- Event notification to trigger Lambda on object upload

### `lambda` module
Deploys the processing function:

- Lambda function package and runtime configuration
- VPC integration (private subnet + security group)
- CloudWatch log group configuration
- Permission for S3 event invocation

### `iam` module
Defines IAM access controls:

- EC2 role and policy for scoped S3 actions
- Lambda role and policy for S3 and CloudWatch logs
- Principle of least privilege across all identities

## Prerequisites

Before deployment, ensure the following tools and accounts are ready:

- AWS account with permissions to create VPC, EC2, IAM, S3, Lambda, and VPC endpoints
- Terraform v1.5+ installed
- AWS CLI configured with credentials (`aws configure`)
- An S3 object processing Lambda package (or source archive) prepared

Recommended:

- Remote Terraform state backend (S3 + DynamoDB lock table)
- Dedicated AWS account or sandbox environment

## Deploy with Terraform

### 1. Clone repository

```bash
git clone <your-repo-url>
cd TerraformProjectAlphaZero
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review and set variables

Create a `terraform.tfvars` file:

```hcl
aws_region          = "us-east-1"
project_name        = "private-infra"
vpc_cidr            = "10.10.0.0/16"
private_subnet_cidrs = ["10.10.1.0/24", "10.10.2.0/24"]
```

### 4. Validate and plan

```bash
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
```

### 5. Apply

```bash
terraform apply tfplan
```

### 6. Test the flow

- Upload a file to `s3://<bucket-name>/input/`.
- Verify Lambda execution in CloudWatch Logs.
- Confirm processed output appears in `s3://<bucket-name>/output/`.
- From EC2, validate S3 connectivity without internet routes.

### 7. Destroy (when finished)

```bash
terraform destroy
```

## Security Design

This project is intentionally designed with private-by-default principles.

### Network Isolation

- No public subnets are created.
- No Internet Gateway is attached to the VPC.
- No NAT Gateway is provisioned.
- EC2 and Lambda are deployed in private subnets only.

### Controlled Service Access

- S3 traffic stays on AWS private network through the S3 Gateway endpoint.
- CloudWatch Logs traffic uses an interface endpoint in the VPC.
- Security groups allow only required internal traffic.

### Identity and Access Control

- Separate IAM roles for EC2 and Lambda.
- Least-privilege policies scoped to required actions.
- S3 bucket remains private with public access blocked.

### Data and Observability

- Lambda processing outputs are written to controlled S3 prefixes.
- Logs are centralized in CloudWatch Logs through private connectivity.
- Infrastructure can be extended with KMS encryption and audit controls.

## Future Improvements

Potential enhancements for production-grade deployment:

1. Add KMS encryption for S3 objects, Lambda environment variables, and logs.
2. Add VPC endpoints for additional services (STS, ECR, Secrets Manager) as needed.
3. Implement stricter bucket policies using VPC endpoint conditions (`aws:sourceVpce`).
4. Add Terraform CI/CD pipeline with policy checks (tflint, tfsec, checkov).
5. Add CloudWatch alarms and SNS notifications for operational visibility.
6. Introduce autoscaling and high-availability patterns for compute workloads.
7. Move state to a secured remote backend with role-based access controls.

## Notes for Portfolio Presentation

This repository demonstrates practical cloud security architecture skills:

- Designing fully private AWS network topologies
- Enabling private service access through VPC endpoints
- Building event-driven workflows (S3 → Lambda → S3)
- Applying IAM least privilege and infrastructure-as-code best practices

