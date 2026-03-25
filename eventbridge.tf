module "eventbridge" {
  source  = "terraform-aws-modules/eventbridge/aws"
  version = "4.3.0"

  create_bus = false

  rules = {
    s3_image_uploaded = {
      event_pattern = jsonencode({
        source      = ["aws.s3"]
        detail-type = ["Object Created"]
        detail = {
          bucket = { name = [aws_s3_bucket.pre_processed.id] }
        }
      })
    }
  }

  targets = {
    s3_image_uploaded = [
      {
        name = "process-image"
        arn  = aws_lambda_function.process_image.arn
      },
      {
        name = "send-email"
        arn = aws_sns_topic.test.arn
      }
    ]

  }

  tags = {
    environment = "test"
    managedBy   = "tf-module"
  }
}