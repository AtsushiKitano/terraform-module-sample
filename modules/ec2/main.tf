resource "aws_instance" "main" {
  ami               = var.ami
  instance_type     = var.instance_type
  availability_zone = var.az
  key_name          = aws_key_pair.main.key_name

  network_interface {
    network_interface_id = aws_network_interface.main.id
    device_index         = 0
  }

  tags = {
    Name = var.name
  }
}

resource "aws_network_interface" "main" {
  subnet_id       = var.subnet
  security_groups = var.sgs
  tags = {
    Name = var.name
  }
}

resource "aws_eip" "main" {
  depends_on = [
    aws_instance.main
  ]

  vpc               = true
  network_interface = aws_network_interface.main.id
  tags = {
    Name = var.name
  }
}

resource "aws_key_pair" "main" {
  key_name   = var.name
  public_key = var.public_key
}
