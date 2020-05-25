
// rds - connection - permissins - arn
//locals {
// //rds-conn-permission-arn = format("arn:aws:rds-db:%s:%s:dbuser:%s/%s",module.rds.current-region, module.rds.aws_account_id, module.rds.rds-instance-resourceId, module.rds.rds-dbuser)
// rds-conn-permission-arn = "arn:aws:rds-db:,${module.rds.current-region},:,${module.rds.aws_account_id},:,${module.rds.rds-instance-resourceId},:,${module.rds.rds-dbuser}"
//}
//
//output "rds-connection-permissins-arn" {
// value = local.rds-conn-permission-arn
//}
