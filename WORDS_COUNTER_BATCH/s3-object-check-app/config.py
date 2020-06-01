import yaml
import rds_functions


conf = yaml.safe_load(open('app_config.yml'))

# grabbing rds info and credentials :
rds_name = conf['rds']['name']
aws_secret_manager = conf['rds']['awsSecretmanagerName']

rds_host = rds_functions.rds_info(rds_name)['db_address']
name = rds_functions.rds_info(rds_name)['db_user']
password = rds_functions.aws_secret_manager_get_secret_value(aws_secret_manager, 'SecretString', 'password')
db_name = rds_functions.rds_info(rds_name)['db_name']


# openfaas info
openfaas_url = conf['openfaas']['url']
openfaas_function = conf['openfaas']['functionName']