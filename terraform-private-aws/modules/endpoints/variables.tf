variable "name" {
  type        = string
  description = "Name prefix"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_route_table_id" {
  type        = string
  description = "Private route table ID"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDR ranges"
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}
