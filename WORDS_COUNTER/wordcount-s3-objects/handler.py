import boto3
import os
import logging
import re
from botocore.exceptions import ClientError


def handle(bucket_object_path):
    try:
        """ bucket_object_path format = "mybucket/myfile" | "mybucket/dir/myfile" """
        aws_key = os.environ.get('AWS_ACCESS_KEY_ID')
        aws_access_secret = os.environ.get('AWS_SECRET_ACCESS_KEY')
        region = os.environ.get('AWS_DEFAULT_REGION')
        bucket_name = bucket_object_path.partition("/")[0]
        object_name = bucket_object_path.partition("/")[2]
        s3_resource = boto3.resource('s3', aws_access_key_id=aws_key, aws_secret_access_key=aws_access_secret, region_name=region)
        Objects = s3_resource.Bucket(bucket_name)
        for obj in Objects.objects.all():
            if object_name in obj.key:
                body = obj.get()['Body'].read().decode('utf-8')
                words_count = len(re.findall(r'\w+', body))
                return "Words Count in file : " + str(words_count) + "\n" \
                       "Contents of the latest s3 object : " + "\n" + body
    except ClientError as e:
        logging.error(e)
        return logging.error(e), False


"""
Find last file in S3 :
         s3 = boto3.client('s3')
        keys = []
        response = s3.list_objects_v2(Bucket=bucket_name, Delimiter="\n", Prefix='data')
        for obj in response['Contents']:
            keys.append(obj['Key'])
        last_modified_object = keys[-1]
"""