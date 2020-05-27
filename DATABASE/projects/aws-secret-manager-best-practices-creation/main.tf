provider "aws" {
  region = "us-east-1"
}

data "aws_db_instance" "rds-generic" {
  db_instance_identifier = "generic-mysql-instances"
}

resource "aws_secretsmanager_secret" "create-secret-manager" {
  depends_on = [data.aws_db_instance.rds-generic]
  name = "test6-creds"
}

/* Using template file new function : https://www.terraform.io/docs/configuration/functions/templatefile.html */

//sensitive, if we miss a quoation , aws will create the secret but it will not convert it into key:value format
resource "aws_secretsmanager_secret_version" "create-rds-creds" {
  depends_on = [aws_secretsmanager_secret.create-secret-manager]
  secret_id = aws_secretsmanager_secret.create-secret-manager.id
  // db_instance_identifier is the same as id
  secret_string = <<EOF
{
  "username": "${data.aws_db_instance.rds-generic.master_username}",
  "password": "FJkvnLX5Qb",
  "engine": "mysql",
  "host": "${data.aws_db_instance.rds-generic.address}",
  "port": ${data.aws_db_instance.rds-generic.port},
  "dbname": "${data.aws_db_instance.rds-generic.db_name}",
  "dbInstanceIdentifier": "${data.aws_db_instance.rds-generic.id}"
}
EOF
}

/*
// Second option but preferable using jsonencode, but the json in Amazon will be flipped
resource "aws_secretsmanager_secret_version" "create-rds-creds" {
  depends_on = [aws_secretsmanager_secret.create-secret-manager]
  secret_id = aws_secretsmanager_secret.create-secret-manager.id
  // db_instance_identifier is the same as id
  secret_string = jsonencode({
    "username": data.aws_db_instance.rds-generic.master_username,
    "password": "FJkvnLX5Qb",
    "engine": "mysql",
    "host": data.aws_db_instance.rds-generic.address,
    "port": data.aws_db_instance.rds-generic.port,
    "dbname": data.aws_db_instance.rds-generic.db_name,
    "dbInstanceIdentifier": data.aws_db_instance.rds-generic.id
  })
}
/*
