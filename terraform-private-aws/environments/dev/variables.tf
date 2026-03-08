variable "region" {
  type        = string
  description = "AWS region"
}

variable "project_name" {
  type        = string
  description = "Resource name prefix"
  default     = "private-aws-dev"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
  default     = "10.20.0.0/16"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs"
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name"
}

variable "input_prefix" {
  type        = string
  description = "S3 trigger prefix"
  default     = "incoming/"
}

variable "output_prefix" {
  type        = string
  description = "S3 output prefix"
  default     = "processed/"
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}
