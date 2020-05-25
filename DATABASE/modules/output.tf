// These outputs are for lambda funtion in LINES_COUNTER dir

output "default-sg" {
  value = data.aws_security_group.default.id
}
output "rds-sg" {
  value = data.aws_security_group.rds-sg.id
}

output "subnet1" {
  value = data.aws_subnet.rds_subnet_id_1.vpc_id
}
output "subnet2" {
  value = data.aws_subnet.rds_subnet_id_2.vpc_id
}

// For connecting lambda to rds
output "rds-instance-resourceId" {
  value = aws_db_instance.rds_instance.resource_id
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "current-region" {
  value = data.aws_region.current.name
}

output "rds-dbuser" {
  value = module.global_vars.rds_project_dbuser
}
