# s3-eventbridge-lambda

Tests out a very simple flow with the following:
- 2 S3 Buckets (pre-processed and processed)
- EventBridge (one rule to invoke Lambda to put file into processed and another to email TSF email on successful upload (to be tweaked - filtering possible))
- Lambda function that does super basic processing of image and uploads to processed bucket


