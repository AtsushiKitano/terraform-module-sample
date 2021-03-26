variable "vpc_name" {
  type = string
}

variable "cidr" {
  type = string
}

variable "subnets" {
  type = list(object({
    cidr = string
    az   = string
    name = string
  }))
}

variable "ig_name" {
  type = string
}

variable "route_table_name" {
  type = string
}

variable "default_route_table_name" {
  type = string
}

variable "route_internet" {
  type = list(string)
}

variable "acl_name" {
  type = string
}

variable "defalut_acl_name" {
  type = string
}

variable "acl_rules" {
  type = list(object({
    priority    = number
    egress      = bool
    protocol    = string
    cidr        = string
    rule_action = string
    from_port   = number
    to_port     = number
  }))
}
