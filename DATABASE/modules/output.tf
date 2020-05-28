// These outputs are for lambda funtion in LINES_COUNTER dir

//output "default-sg" { value = data.aws_security_group.default.id }
//output "rds-sg" { value = data.aws_security_group.rds-sg.id }
//output "subnet1" { value = data.aws_subnet.rds_subnet_id_1.vpc_id }
//output "subnet2" { value = data.aws_subnet.rds_subnet_id_2.vpc_id }
//output "aws_account_id" { value = data.aws_caller_identity.current.id }
//output "current-region" { value = data.aws_region.current.name }
//output "rds-dbuser" { value = module.global_vars.rds_project_dbuser }

// Additional if needed
//output "aws_secret_manager_name" { value = aws_secretsmanager_secret.create-secret-manager.name }
//output "aws_secret_manager_arn" { value = aws_secretsmanager_secret.create-secret-manager.arn }
//output "aws_db_identifier" { value = aws_db_instance.rds_instance.identifier }
//output "aws_db_resource_id" { value = aws_db_instance.rds_instance.resource_id }