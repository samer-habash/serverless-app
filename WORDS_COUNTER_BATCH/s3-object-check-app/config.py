import yaml
import rds_functions

db = yaml.safe_load(open('RDS_config.yaml'))
rds_name = db['rds']['name']
aws_secret_manager = db['rds']['awsSecretmanagerName']

# grabbing rds info and credentials :
rds_host = rds_functions.rds_info(rds_name)['db_address']
name = rds_functions.rds_info(rds_name)['db_user']
password = rds_functions.aws_secret_manager_get_secret_value(aws_secret_manager, 'SecretString', 'password')
db_name = rds_functions.rds_info(rds_name)['db_name']
