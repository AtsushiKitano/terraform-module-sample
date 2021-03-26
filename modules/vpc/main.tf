locals {
  subnet_ids = [
    for v in var.subnets : aws_subnet.main[v.name].id
  ]
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "main" {
  for_each = { for v in var.subnets : v.name => v }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags = {
    Name = each.value.name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.ig_name
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = toset(var.route_internet)
    iterator = _conf

    content {
      cidr_block = _conf.value
      gateway_id = aws_internet_gateway.main.id
    }
  }

  tags = {
    Name = var.route_table_name
  }
}

resource "aws_network_acl" "main" {
  depends_on = [
    aws_subnet.main
  ]
  vpc_id     = aws_vpc.main.id
  subnet_ids = local.subnet_ids

  tags = {
    Name = var.acl_name
  }
}

resource "aws_network_acl_rule" "main" {
  for_each = { for v in var.acl_rules : join("-", [v.rule_action, v.protocol, v.priority, v.from_port, v.to_port]) => v }

  network_acl_id = aws_network_acl.main.id
  rule_number    = each.value.priority
  egress         = each.value.egress
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  cidr_block     = each.value.cidr
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}

resource "aws_default_network_acl" "main" {
  default_network_acl_id = aws_vpc.main.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.main.cidr_block
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 32766
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = var.defalut_acl_name
  }
}

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name = var.default_route_table_name
  }
}

resource "aws_security_group" "main" {
  name   = var.sg.name
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.sg.ingress_rules
    iterator = _conf

    content {
      from_port   = _conf.value.from
      to_port     = _conf.value.to
      protocol    = _conf.value.protocol
      cidr_blocks = _conf.value.cidrs
    }
  }

  tags = {
    Name = var.sg.name
  }
}
