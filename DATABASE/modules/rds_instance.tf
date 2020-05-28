module "global_vars" {
  source = "../projects/global-variables"
}

resource "aws_db_instance" "rds_instance" {
  // If we use identifier it will overwrite the instance_id of the db instance,
  //we should use in elb to get the instance_identifier and no the instacne_id
  identifier = module.global_vars.rds_identifier
  allocated_storage = module.global_vars.rds_allocated_storage
  storage_type = module.global_vars.rds_storage_type
  engine = module.global_vars.rds_engine
  engine_version = module.global_vars.rds_engine_version
  instance_class = module.global_vars.rds_instance_class
  name = module.global_vars.rds_project_dbname
  username = module.global_vars.rds_project_dbuser
  password = module.global_vars.rds_random_pass_generation
  port = module.global_vars.project_rds_internal_dbport
  parameter_group_name = module.global_vars.rds_parameter_group_name

  // IAM db authentication through AWS IAM users and roles (lambda can get access)
  iam_database_authentication_enabled = true

  //(Optional) Determines whether a final DB snapshot is created before the DB instance is deleted.
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.rds_subnet.name

  // security group default+rds
  vpc_security_group_ids = [data.aws_security_group.default.id, aws_security_group.rds_sg.id]
  //db_subnet_group_name = aws_db_subnet_group.rds_subnet.name
  // I will use public accesibility in order to let me PC connects directly from mysql-workbench
  publicly_accessible = true
  //  lifecycle {
  //    prevent_destroy = true
  //  }
  // Ignore recreation of rds password everytime I run the terraform (when using generate password)
  //  lifecycle {
  //    ignore_changes = [password]
  //  }
}