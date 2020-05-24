resource "random_password" "rds_random_pass" {
  length = 16
  special = true
  override_special = "$%*"
}