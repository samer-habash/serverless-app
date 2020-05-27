resource "aws_db_subnet_group" "rds_subnet" {
  name = join("-", [module.global_vars.rds_project_name_vars, "subnet"])
  subnet_ids = [data.aws_subnet.rds_subnet_id_1.id, data.aws_subnet.rds_subnet_id_2.id]
  tags = {
    Name = "RDS Subnet group us-east-1a/b"
  }
  lifecycle {
    prevent_destroy = true
  }
}