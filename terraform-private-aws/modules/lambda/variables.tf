variable "name" {
  type        = string
  description = "Name prefix"
}

variable "source_file" {
  type        = string
  description = "Path to lambda handler source file"
}

variable "role_arn" {
  type        = string
  description = "Lambda execution role ARN"
}

variable "output_prefix" {
  type        = string
  description = "Prefix where transformed data is written"
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}
