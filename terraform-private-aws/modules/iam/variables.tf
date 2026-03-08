variable "name" {
  type        = string
  description = "Name prefix"
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name used by EC2 and Lambda policies"
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}
