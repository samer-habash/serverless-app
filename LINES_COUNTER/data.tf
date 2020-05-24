module "rds" {
  source = "../DATABASE/modules"
}

data "aws_s3_bucket" "s3-bucket" {
  bucket = "samh-s3-bucket"
}
