data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/src/handler.py"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "process_image" {
  function_name = "image-processor"
  role          = aws_iam_role.lambda.arn
  handler       = "handler.handler"
  runtime       = "python3.12"
  filename      = data.archive_file.lambda.output_path
  code_sha256   = data.archive_file.lambda.output_base64sha256
  timeout       = 60
  memory_size   = 256

  environment {
    variables = {
      DEST_BUCKET = aws_s3_bucket.processed.id
    }
  }
}