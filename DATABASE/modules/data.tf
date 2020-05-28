data "aws_vpc" "default" { default = true }
data "aws_region" "current" { name = "us-east-1" }
data "aws_security_group" "default" { name = "default" }
data "aws_security_group" "rds-sg" { id = aws_security_group.rds_sg.id }
data "aws_caller_identity" "current" {}

data "aws_subnet" "rds_subnet_id_1" {
  availability_zone = "us-east-1a"
  vpc_id = data.aws_vpc.default.id
}

data "aws_subnet" "rds_subnet_id_2" {
  availability_zone = "us-east-1b"
  vpc_id = data.aws_vpc.default.id
}

// This we will use to grab all the paramters after rds creation
data "aws_db_instance" "rds-usage-after-creation" {
  depends_on = [aws_db_instance.rds_instance]
  db_instance_identifier = module.global_vars.rds_identifier
}