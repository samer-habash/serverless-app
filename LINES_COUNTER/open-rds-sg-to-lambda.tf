resource "aws_security_group_rule" "ingress_allow_lambda_to_RDS" {
  security_group_id = data.aws_security_group.rds-sg.id
  from_port         = 3306
  to_port           = 3306
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
}