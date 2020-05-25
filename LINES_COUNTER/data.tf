module "rds" {
  source = "../DATABASE/modules"
}

data "aws_s3_bucket" "s3-bucket" {
  bucket = "samh-s3-bucket"
}

data "aws_secretsmanager_secret" "rds_creds" {
  arn = "arn:aws:secretsmanager:us-east-1:399728276788:secret:rds-credentials-KE5hdR"
}