output "rds_project_name_vars" {
  value = join("-", [local.project_name.rds.enviornment, local.project_name.rds.name])
}
output "rds_region" { value = local.project_name.rds.region }
output "rds_project_dbname" { value = local.project_name.rds.dbname }
output "rds_project_dbuser" { value = local.project_name.rds.dbuser }
output "rds_project_pass" { value = local.project_name.rds.password }
output "project_rds_internal_dbport" { value = local.project_name.rds.db_port }
output "project_rds_external_dbport" { value = local.project_name.rds.external_db_port }
output "rds_random_pass_generation" { value = local.project_name.rds.password }
output "rds_allocated_storage" { value = local.project_name.rds.allocated_storage }
output "rds_identifier" { value = local.project_name.rds.identifier }
output "rds_storage_type" { value = local.project_name.rds.storage_type }
output "rds_engine" { value = local.project_name.rds.engine }
output "rds_engine_version" { value = local.project_name.rds.engine_version }
output "rds_instance_class" { value = local.project_name.rds.instance_class }
output "rds_parameter_group_name" { value = local.project_name.rds.parameter_group_name }
output "rds_secret_manager_name" { value = local.project_name.aws_rds_secret_manager.name }

// if you wanna use the generate pass then uncomment this output to be reachable for the main project as module.rds_random_pass_generation
//output "rds_random_pass_generation" {
//  value = random_password.rds_random_pass.result
//}

