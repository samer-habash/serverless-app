output "rds_project_name_vars" {
  value = join("-", [local.project_name.rds.enviornment, local.project_name.rds.name])
}

output "rds_project_dbname" {
  value = local.project_name.rds.dbname
}

output "rds_project_dbuser" {
  value = local.project_name.rds.dbuser
}

output "rds_project_pass" {
  value = local.project_name.rds.password
}

output "project_rds_internal_dbport" {
  value = local.project_name.rds.db_port
}

output "project_rds_external_dbport" {
  value = local.project_name.rds.external_db_port
}

output "rds_random_pass_generation" {
  value = random_password.rds_random_pass.result
}

