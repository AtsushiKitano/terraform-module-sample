output "subnet_id" {
  value = { for v in var.subnets : v.name => aws_subnet.main[v.name].id }
}

output "sg_id" {
  value = aws_security_group.main.id
}
