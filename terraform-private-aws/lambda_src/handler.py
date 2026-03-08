import os
import urllib.parse
import boto3

s3 = boto3.client("s3")
OUTPUT_PREFIX = os.environ.get("OUTPUT_PREFIX", "processed/")


def lambda_handler(event, context):
    """
    Triggered by S3 ObjectCreated events.
    Reads object content from incoming prefix and writes transformed content
    to the configured processed prefix.
    """
    for record in event.get("Records", []):
        bucket = record["s3"]["bucket"]["name"]
        key = urllib.parse.unquote_plus(record["s3"]["object"]["key"])

        # Prevent processing loops when Lambda writes output back to the same bucket.
        if key.startswith(OUTPUT_PREFIX):
            continue

        body = s3.get_object(Bucket=bucket, Key=key)["Body"].read().decode("utf-8")
        transformed = body.upper()

        output_key = f"{OUTPUT_PREFIX}{key.split('/')[-1]}"
        s3.put_object(
            Bucket=bucket,
            Key=output_key,
            Body=transformed.encode("utf-8"),
            ContentType="text/plain",
        )

    return {"statusCode": 200, "message": "Processing complete"}
