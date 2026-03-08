variable "name" {
  type        = string
  description = "Name prefix"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "subnet_id" {
  type        = string
  description = "Private subnet for EC2 deployment"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "iam_instance_profile_name" {
  type        = string
  description = "IAM instance profile name"
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}
