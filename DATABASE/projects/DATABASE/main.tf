provider "aws" {
  region = "us-east-1"
}

module "rds_DATABASE" {
  source = "../../modules"
}