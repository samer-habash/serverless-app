resource "aws_security_group" "rds_sg" {
  name = join("-", [module.global_vars.rds_project_name_vars, "sg"])
  vpc_id = data.aws_vpc.default.id
  //    lifecycle {
  //    prevent_destroy = true
  //  }
}

// This will allow lambda and everyone access to rds
resource "aws_security_group_rule" "ingress_allow_all_rds" {
  security_group_id = aws_security_group.rds_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = -1
  type              = "ingress"
  self              = true
}

resource "aws_security_group_rule" "egress_allow_all_rds" {
  from_port         = 0
  protocol          = "TCP"
  security_group_id = aws_security_group.rds_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  to_port           = 0
  type              = "egress"
}