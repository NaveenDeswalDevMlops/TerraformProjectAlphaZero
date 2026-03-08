variable "region" {
  description = "AWS region for all resources"
  type        = string
}

variable "project_name" {
  description = "Name prefix applied to resources"
  type        = string
  default     = "private-aws"
}

variable "vpc_cidr" {
  description = "CIDR block for the private VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "Two private subnet CIDR ranges in different AZs"
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "bucket_name" {
  description = "Unique private S3 bucket name"
  type        = string
}

variable "input_prefix" {
  description = "S3 prefix that triggers Lambda processing"
  type        = string
  default     = "incoming/"
}

variable "output_prefix" {
  description = "S3 prefix where Lambda writes processed output"
  type        = string
  default     = "processed/"
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}
