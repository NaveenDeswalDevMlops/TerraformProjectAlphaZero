data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = var.source_file
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "this" {
  function_name = "${var.name}-s3-processor"
  role          = var.role_arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.11"
  timeout       = 30

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      OUTPUT_PREFIX = var.output_prefix
    }
  }

  tags = var.tags
}
