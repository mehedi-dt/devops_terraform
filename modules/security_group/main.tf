resource "aws_security_group" "this" {
  name = var.sg_name
  description = "Security group for ${var.sg_name}. ${var.sg_description}"
  vpc_id = var.vpc_id

  tags = {
    Name = var.sg_name
    Env = var.env
  }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  security_group_id = aws_security_group.this.id

  for_each = { for i, j in var.ingress : i => j}

  from_port = each.value.from_port
  to_port = each.value.to_port
  ip_protocol = each.value.protocol
  cidr_ipv4 = each.value.cidr_block
  referenced_security_group_id = each.value.sg_id
}

resource "aws_vpc_security_group_egress_rule" "this" {
  security_group_id = aws_security_group.this.id

  for_each = {for i, j in var.egress : i => j}

  from_port = each.value.from_port
  to_port = each.value.to_port
  ip_protocol = each.value.protocol
  cidr_ipv4 = each.value.cidr_block
  referenced_security_group_id = each.value.sg_id
}