import boto3
import os
import base64
from io import BytesIO

s3 = boto3.client("s3")
DEST_BUCKET = os.environ["DEST_BUCKET"]


def handler(event, context):
    source_bucket = event["detail"]["bucket"]["name"]
    key = event["detail"]["object"]["key"]

    # Download from pre-processed bucket
    response = s3.get_object(Bucket=source_bucket, Key=key)
    image_bytes = response["Body"].read()
    content_type = response.get("ContentType", "image/jpeg")

    # Add metadata to mark it as processed, upload to processed bucket
    s3.put_object(
        Bucket=DEST_BUCKET,
        Key=key,
        Body=image_bytes,
        ContentType=content_type,
        Metadata={
            "processed": "true",
            "source-bucket": source_bucket,
        },
    )

    return {
        "statusCode": 200,
        "key": key,
        "size_bytes": len(image_bytes),
    }