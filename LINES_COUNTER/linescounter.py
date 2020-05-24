import boto3
import json
import string
import sys
import random
import logging
import pymysql

def aws_secret_manager_get_secret_value(secret_name, secret_string, key_entry):
    client = boto3.client('secretsmanager')
    response = client.get_secret_value(SecretId=secret_name)
    result = response.get(secret_string)
    result = result.replace("\"", "").split(",")
    key_entry_index = [i for i in range(len(result)) if key_entry in result[i]]
    key_entry_index_num = str(key_entry_index).replace("{", "").replace("}", "").strip('[]')
    key_entry_value = result[int(key_entry_index_num)].split(":", 1)[1]
    return key_entry_value


def rds_info(rds_name):
    client = boto3.client('rds')
    response = client.describe_db_instances()
    for r in response['DBInstances']:
        if rds_name in r['DBInstanceIdentifier']:
            response_rds = client.describe_db_instances(
                DBInstanceIdentifier=rds_name,
                MaxRecords=100
            )
            return dict(db_identifier=r['DBInstanceIdentifier'], db_instance_type=r['DBInstanceClass'],
                        db_user=r['MasterUsername'],
                        db_name=r['DBName'], db_address=r['Endpoint']['Address'], db_port=r['Endpoint']['Port'],
                        db_arn=r['DBInstanceArn'], db_security_group=r['VpcSecurityGroups'])
    return False


rds_host = rds_info('generic-mysql-instances')['db_address']
name = rds_info('generic-mysql-instances')['db_user']
password = aws_secret_manager_get_secret_value('rds-credentials', 'SecretString', 'password')
db_name = rds_info('generic-mysql-instances')['db_name']
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def id_generator(size=6, chars=string.ascii_uppercase + string.digits):
    return ''.join(random.choice(chars) for _ in range(size))


def lambda_handler(event, context):
    s3 = boto3.client('s3')
    bucket_name = str(event["Records"][0]["s3"]["bucket"]["name"])
    key_name = str(event["Records"][0]["s3"]["object"]["key"])
    obj = s3.get_object(Bucket=bucket_name, Key=key_name)
    body_len = len(obj['Body'].read().decode('utf-8').split("\n"))
    try:
        conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=60)
        with conn.cursor() as cur:
            cur.execute("INSERT INTO LinesCount(id, ObjectPath, AmountOfLines) \
                        values(%s, %s, %s) % (id_generator(), obj, body_len)")
            conn.commit()
    except pymysql.MySQLError as e:
        logger.error("ERROR: Unexpected error: Could not connect to MySQL instance.")
        logger.error(e)
        sys.exit(1)
    return {
        'statusCode': 200,
        'body': json.dumps('S3 succesfully Calculated and inserted in RDS!')
    }
