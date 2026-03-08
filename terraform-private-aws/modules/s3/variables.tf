variable "bucket_name" {
  type        = string
  description = "Private S3 bucket name"
}

variable "lambda_function_arn" {
  type        = string
  description = "Lambda ARN for S3 event notifications"
}

variable "lambda_function_name" {
  type        = string
  description = "Lambda function name for invoke permissions"
}

variable "input_prefix" {
  type        = string
  description = "Prefix that triggers processing"
  default     = "incoming/"
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}
