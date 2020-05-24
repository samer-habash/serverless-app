module "global_vars" {
  source = "../projects/global-variables"
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage = 20
  // If we use identifier it will overwrite the instance_id of the db instance,
  //we should use in elb to get the instance_identifier and no the instacne_id
  identifier = "generic-mysql-instances"
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7.22"
  instance_class = "db.t2.micro"
  name = module.global_vars.rds_project_dbname
  username = module.global_vars.rds_project_dbuser
  //Grab the random pass generated from global_vars
  password = module.global_vars.rds_random_pass_generation
  port = module.global_vars.project_rds_internal_dbport
  parameter_group_name = "default.mysql5.7"
  // IAM db authentication through AWS IAM users and roles (lambda can get access)
  iam_database_authentication_enabled = true
  skip_final_snapshot = true
  // security group default+rds
  vpc_security_group_ids = [data.aws_security_group.default.id, aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.rds_subnet.name
  // I will use public accesibility in order to let me PC connects directly from mysql-workbench
  publicly_accessible = true
  // Ignore recreation of rds password everytime I run the terraform .
  lifecycle {
    ignore_changes = [password]
  }
}