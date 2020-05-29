import boto3
import json
import sys
import random
import logging
import pymysql

"""
Note the name of the rds and aws secret manager is hardcoded , and the program will grab the secret value, 
    and the relevant parameters to connect.
"""

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
password = aws_secret_manager_get_secret_value('rds-cred', 'SecretString', 'password')
db_name = rds_info('generic-mysql-instances')['db_name']
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def id_generator():
    # id columns in mysql is INT signed which has the maximum of 2147483648
    value = random.randint(0, 2147483648)
    return value


def handler(event, context):
    s3 = boto3.client('s3')
    s3_resource = boto3.resource('s3')
    bucket_name = event["Records"][0]["s3"]["bucket"]["name"]
    key_name = event["Records"][0]["s3"]["object"]["key"]
    obj = s3.get_object(Bucket=bucket_name, Key=key_name)
    obj_path = "S3://" + bucket_name + "/" + key_name
    body_len = len(obj['Body'].read().decode('utf-8').split("\n"))
    size = event["Records"][0]["s3"]["object"]["size"]

    # Connecting to Mysql with open connection :
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=30)
    try:
        cur = conn.cursor()
        sql = cur.execute("""INSERT INTO LinesCount (id, ObjectPath, AmountOfLines) VALUES ("%s", "%s", "%s")""" % (id_generator(), obj_path, body_len))
        conn.commit()
    except pymysql.MySQLError as e:
        print(e)
        logger.error("ERROR: Unexpected error: Could not connect to MySQL instance.")
        logger.error(e)
        sys.exit()
    return {
        'statusCode': 200,
        'body': json.dumps('S3 file lines successfully calculated and the calculations :  LinesCount : %s were inserted in RDS!' % body_len)
    }