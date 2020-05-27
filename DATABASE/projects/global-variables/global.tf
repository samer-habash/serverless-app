// shared RDS variable

locals {
  project_name = {
    rds = {
      enviornment = "dev"
      name = "rds"
      dbname = "lambdalines"
      dbuser = "sam"
      // for usage of random pass
      // password = random_password.rds_random_pass.result
      password = "FJkvnLX5Qb"
      // password is directly generated from rds_instance
      db_port = 3306
      external_db_port = 3306
      allocated_storage = 20
      identifier = "generic-mysql-instances"
      storage_type = "gp2"
      engine = "mysql"
      engine_version = "5.7.22"
      instance_class = "db.t2.micro"
      parameter_group_name = "default.mysql5.7"
    }
    // For another projects , etc ...
  }
}
