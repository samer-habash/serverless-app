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