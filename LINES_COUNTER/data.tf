module "rds_global_vars" {
  source = "../DATABASE/projects/global-variables"
}

// bucket name is pre-created form before
data "aws_s3_bucket" "s3-bucket" { bucket = "samh-s3-bucket" }
data "aws_db_instance" "rds-usage-after-creation" { db_instance_identifier = module.rds_global_vars.rds_identifier }
data "aws_secretsmanager_secret" "aws-secret-after-creation" { name = module.rds_global_vars.rds_secret_manager_name }
data "aws_caller_identity" "current" {}

