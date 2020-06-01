#!/usr/bin/env python3

from datetime import datetime, timedelta
from dateutil.tz import tzutc
import boto3
import sys
import requests
import os
import logging
import pymysql
# path = sys.path.append('../dir')
from config import rds_host, name, password, db_name


def download_s3_object(bucket_name, object_name, file_name):
    s3 = boto3.client('s3')
    result = s3.download_file(bucket_name, object_name, file_name)
    return result


def response_from_openfaas(bucket_name, object_name):
    # Put here your openfaas external gateway IP
    url = 'http://10.97.39.41:8080/function/wordcount-s3-objects'
    data = bucket_name + "/" + object_name
    return requests.post(url, data=data).text


conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=30)
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def send_wordscount_to_rds(path, num_of_words):
    try:
        cur = conn.cursor()
        sql = cur.execute(
            """INSERT INTO WordsCount (ObjectPath, AmountOfWords) VALUES ("%s", "%s")""" % (path, num_of_words))
        conn.commit()
    except pymysql.MySQLError as e:
        logger.error("ERROR: Unexpected error: Could not connect to MySQL instance.")
        logger.error(e)
        sys.exit()

    logger.info("SUCCESS: Connection to RDS MySQL instance succeeded")


if __name__ == '__main__':
    region = os.environ.get('AWS_DEFAULT_REGION')
    bucket = sys.argv[1]
    s3_resource = boto3.resource('s3', region_name=region)
    s3_resource_bucket = s3_resource.Bucket(bucket)
    # removing first object since it is the directory with empty file
    for obj in list(s3_resource_bucket.objects.all())[1:]:
        s3 = boto3.client('s3')
        if obj.last_modified > datetime.now(tzutc()) - timedelta(hours=24):
            file = obj.key
            filename = str(obj.key).partition("/")[2]
            download_file = download_s3_object(bucket, file, filename)
            # send it to openfaas in requests method (format bucket/file)
            response = response_from_openfaas(bucket, file)
            split_response = response.split("\n")
            words_count = split_response[0].partition(":")[2].replace(" ", "")
            # Send the result to RDS:
            object_path = "S3://" + bucket + "/" + file
            send_wordscount_to_rds(object_path, words_count)
