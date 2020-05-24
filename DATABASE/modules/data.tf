data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "rds_subnet_id_1" {
  availability_zone = "us-east-1a"
  vpc_id = data.aws_vpc.default.id
}

data "aws_subnet" "rds_subnet_id_2" {
  availability_zone = "us-east-1b"
  vpc_id = data.aws_vpc.default.id
}

data "aws_security_group" "default" {
  name = "default"
}

data "aws_security_group" "rds-sg" {
  id = aws_security_group.rds_sg.id
}
