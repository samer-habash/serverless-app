import boto3


def aws_secret_manager_rds(secret_name, dict_key):
    client = boto3.client('secretsmanager')
    response = client.list_secrets(MaxResults=100)
    for r in response['SecretList']:
        if secret_name in r['Name']:
            get_secret_info = client.describe_secret(SecretId=secret_name)
            result = get_secret_info.get(dict_key)
            return result
    return False


#print(aws_secret_manager_rds('rds-credentials', 'ARN'))
# print the response to get the full keys.


def aws_secret_manager_get_secret_value(secret_name, secret_string, key_entry):
    client = boto3.client('secretsmanager')
    response = client.get_secret_value(SecretId=secret_name)
    result = response.get(secret_string)
    result = result.replace("\"", "").split(",")
    key_entry_index = [i for i in range(len(result)) if key_entry in result[i]]
    key_entry_index_num = str(key_entry_index).replace("{","").replace("}", "").strip('[]')
    key_entry_value = result[int(key_entry_index_num)].split(":", 1)[1]
    return key_entry_value


#aws_secret_manager_get_secret_value('rds-credentials', 'SecretString', 'password')
#aws_secret_manager_get_secret_value('rds-credentials', 'SecretString', 'username')
# print the response to get the full keys.


def rds_info(rds_name):
    client = boto3.client('rds')
    response = client.describe_db_instances()
    for r in response['DBInstances']:
        if rds_name in r['DBInstanceIdentifier']:
            response_rds = client.describe_db_instances(
                DBInstanceIdentifier=rds_name,
                MaxRecords=100
            )
            return dict(db_identifier=r['DBInstanceIdentifier'], db_instance_type=r['DBInstanceClass'], db_user=r['MasterUsername'],
                        db_name=r['DBName'], db_address=r['Endpoint']['Address'], db_port=r['Endpoint']['Port'],
                        db_arn=r['DBInstanceArn'], db_security_group=r['VpcSecurityGroups'])
    return False


#print(rds_info('generic-mysql-instances')['db_arn'])
# print the response to get the full keys.


"""
Direct method through boto3 :
This method below didn't work for the following reasons: 

    We need to create first aws secret manager, then these below functions will grab the data in the rds instance ,
    and applt sql commands to it.
    The RDS must be aurora with cluster as referred by issue : https://github.com/aws/aws-sdk-ruby/issues/1922
    The resourceArn has to be like xxxxxxxx:cluster:aurora-cluster in order to this works.
    In regular rds and also free tier there is not much to do .

client = boto3.client('rds-data')
sql_create = (\"\"\"CREATE TABLE IF NOT EXISTS LinesCount (
    id INT NOT NULL AUTO_INCREMENT,
    ObjectPath varchar(250) DEFAULT NULL,
    AmountOfLines INT DEFAULT NULL,
    Insertion_date datetime default CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE = INNODB;
SHOW COLUMNS FROM LinesCount;
\"\"\")
query = client.batch_execute_statement(database=rds_info('generic-mysql-instances')['db_name'],
                                 secretArn=aws_secret_manager_rds('rds-credentials', 'ARN'),
                                 resourceArn=rds_info('generic-mysql-instances')['db_arn'],
                                 sql=sql_create)
                                 
"""
