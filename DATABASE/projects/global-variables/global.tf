// shared RDS variable

locals {
  project_name = {
    rds = {
      enviornment = "dev"
      name = "rds"
      dbname = "lambdalines"
      dbuser = "sam"
      password = random_password.rds_random_pass.result
      // password is directly generated from rds_instance
      db_port = 3306
      external_db_port = 3306
    }
    // For another projects , etc ...
  }
}