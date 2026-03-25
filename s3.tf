resource "aws_s3_bucket" "pre_processed" {
  bucket = var.pre_processed_bucket_name
}

resource "aws_s3_bucket" "processed" {
  bucket = var.processed_bucket_name
}

resource "aws_s3_bucket_notification" "pre_processed" {
  bucket      = aws_s3_bucket.pre_processed.id
  eventbridge = true
}
