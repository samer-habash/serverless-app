// Important Note : since terraform store the generated pass in the tfstate file so it is better to directly type the pass in the global.tf
// rather than generating a random pass
// uncomment for generating pass
//resource "random_password" "rds_random_pass" {
//  length = 16
//  special = true
//  override_special = "$%*"
//}