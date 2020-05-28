module "global_vars" {
  source = "../global-variables"
}

module "rds_DATABASE" {
  source = "../../modules"
}

provider "aws" {
  region = module.global_vars.rds_region
}