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


def get_s3_object_contents(bucket_name, key_name):
    # session = boto3.Session()
    # s3_client = session.client("s3")
    # file = BytesIO()

    # content = str(f.getvalue())
    # body_len = len(content.split("\n"))
    # print(body_len)
    # print(content)

    s3_resource = boto3.resource('s3')
    bucket = s3_resource.Bucket(bucket_name)
    for obj in bucket.objects.all():
        if key_name in obj.key:
            body = obj.get()['Body'].read().decode('utf-8')
            body_len = len(body.split("\n"))
            print(body_len)
            return body_len


# get_s3_object_contents('samh-s3-bucket', 'data/samh-files-produced-20200525T-10-50.txt')