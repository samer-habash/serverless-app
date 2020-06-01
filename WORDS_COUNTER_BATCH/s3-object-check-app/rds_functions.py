import boto3


def aws_secret_manager_get_secret_value(secret_name, secret_string, key_entry):
    client = boto3.client('secretsmanager')
    response = client.get_secret_value(SecretId=secret_name)
    result = response.get(secret_string)
    result = result.replace("\"", "").split(",")
    key_entry_index = [i for i in range(len(result)) if key_entry in result[i]]
    key_entry_index_num = str(key_entry_index).replace("{", "").replace("}", "").strip('[]')
    key_entry_value = result[int(key_entry_index_num)].split(":", 1)[1]
    return key_entry_value


#print(aws_secret_manager_get_secret_value('rds-cred', 'SecretString', 'password'))


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



