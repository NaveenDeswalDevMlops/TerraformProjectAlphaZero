# Example values for development environment
region        = "us-east-1"
project_name  = "private-aws-dev"
instance_type = "t3.micro"
bucket_name   = "replace-with-unique-private-bucket-name"

private_subnet_cidrs = [
  "10.20.1.0/24",
  "10.20.2.0/24"
]

input_prefix  = "incoming/"
output_prefix = "processed/"

tags = {
  Environment = "dev"
  Project     = "terraform-private-aws"
  Owner       = "platform-team"
}
