// we will use it in boto3 to execute sql statements
// terraform does not support to attach the secret manager to RDS instance .
// So I did the secret key and upload it as hardcoded json as here :


// #########App this code in this code##########
//resource "aws_secretsmanager_secret" "rds-secret" {
//  name = "rds-secret"
//  depends_on = [aws_db_instance.rds_instance]
//}
//
//resource "aws_secretsmanager_secret_version" "rds-creds-version" {
//  secret_id = aws_secretsmanager_secret.rds-secret.id
//  // This will take the variable below and apply it as json format
//  secret_string = jsonencode(module.global_vars.rds_credentials_map)
//  lifecycle {
//    ignore_changes = [secret_string]
//  }
//}

// ######### App this code in this global-variables/global-outputs.tf ##########
//output "rds_credentials_map" {
//  value = var.rds_map_creds
//}

// ######### App this hardcoded code in this global-variables/variables.tf ##########
// ######### NOTE type directly in string format -> terraform variables does not allow taking the value from another output/variable
//variable "rds_map_creds" {
//  default = {
//    username = myuser
//    password = mypass
//    host = rds-endpoint
//    port = 3306
//    dbname = db-name
//    dbInstanceIdentifier = generic-mysql-instances
//  }
//  type = map
//}