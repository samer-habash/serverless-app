import logging
import boto3
from botocore.exceptions import ClientError
import os


def create_bucket(bucket_name):
    try:
        region = os.environ.get('AWS_DEFAULT_REGION')
        if region is None:
            # It will create the S3 on us-east-1 as a default region
            s3_client = boto3.client('s3')
            s3_client.create_bucket(Bucket=bucket_name)
        else:
            s3_client = boto3.client('s3', region_name=region)
            location = {'LocationConstraint': region}
            s3_client.create_bucket(bucket_name=bucket_name, CreateBucketConfiguration=location)
    except ClientError as e:
        logging.error(e)
        return False
    return True


def upload_file_to_s3(file_name, bucket_name, object_name):
    s3 = boto3.client('s3')
    try:
        response = s3.upload_file(file_name, bucket_name, object_name)
    except ClientError as e:
        logging.error(e)
        return False
    return True


def check_uploaded_file_size(bucket_name, key):
    s3 = boto3.resource('s3')
    object = s3.Object(bucket_name, key)
    # size in bytes
    size = object.content_length
    return size