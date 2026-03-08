variable "name" {
  type        = string
  description = "Name prefix used for VPC resources"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Two private subnet CIDR blocks"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones aligned to private subnet CIDRs"
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}
