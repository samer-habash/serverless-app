// Note The aws secret will be created and the creds will be stored.
/*
    Important NOTE : Terraform does not yet support to attach the RDS in aws secret management.
    So I do it through json , Or use boto3 directly
*/

resource "aws_secretsmanager_secret" "create-secret-manager" {
  depends_on = [aws_db_instance.rds_instance]
  name = module.global_vars.rds_secret_manager_name
}

resource "aws_secretsmanager_secret_version" "create-rds-creds" {
  depends_on = [aws_secretsmanager_secret.create-secret-manager]
  secret_id = aws_secretsmanager_secret.create-secret-manager.id
  // db_instance_identifier is the same as id
  // used host and port to be grabbed from data after rds creations
  secret_string = jsonencode({
    "username": module.global_vars.rds_project_dbuser,
    "password": module.global_vars.rds_project_pass,
    "engine": module.global_vars.rds_engine,
    "host": data.aws_db_instance.rds-usage-after-creation.address,
    "port": data.aws_db_instance.rds-usage-after-creation.port,
    "dbname": module.global_vars.rds_project_dbname,
    "dbInstanceIdentifier": data.aws_db_instance.rds-usage-after-creation.id
  })
  // This is if you choose generate password , so it will not change the pass everytime.
  // I also add it into the rds resource and add the depends on random pass generation
  // depends_on = [aws_secretsmanager_secret.create-secret-manager, module.global_vars.rds_random_pass_generation]
  //  lifecycle {
  //    ignore_changes = [secret_string]
  //  }
}