locals {
  name = "sample"
  az   = "us-east-2a"
  ami  = data.aws_ami.ubuntu.id
}

variable "ssh_key" {
  type = string
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
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
      az   = local.az
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

  sg = {
    name = local.name
    ingress_rules = [
      {
        from     = 22
        to       = 22
        protocol = "tcp"
        cidrs    = ["0.0.0.0/0"]
      }
    ]
  }
}

module "ec2" {
  source = "../modules/ec2"

  name          = local.name
  subnet        = module.vpc.subnet_id[local.name]
  az            = local.az
  instance_type = "t2.micro"
  ami           = local.ami
  sgs           = [module.vpc.sg_id]
  public_key    = file(var.ssh_key)
}
