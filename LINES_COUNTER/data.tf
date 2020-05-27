module "rds" {
  source = "../DATABASE/modules"
}

// bucket name is pre-created form before
data "aws_s3_bucket" "s3-bucket" { bucket = "samh-s3-bucket" }