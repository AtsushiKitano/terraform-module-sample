locals {
  name = "sample"
}

module "vpc" {
  source = "../modules/vpc"

  vpc_name                 = local.name
  ig_name                  = local.name
  acl_name                 = local.name
  route_table_name         = local.name
  defalut_acl_name         = "default-${local.name}"
  default_route_table_name = "default-${local.name}"

  cidr = "10.10.0.0/24"

  subnets = [
    {
      name = local.name
      cidr = "10.10.0.0/28"
      az   = "us-east-2a"
    }
  ]

  route_internet = [
    "0.0.0.0/0"
  ]

  acl_rules = [
    {
      priority    = 200
      egress      = false
      protocol    = "tcp"
      rule_action = "allow"
      cidr        = "0.0.0.0/0"
      from_port   = 22
      to_port     = 22
    }
  ]
}
