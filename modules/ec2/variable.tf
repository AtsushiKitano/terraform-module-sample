variable "name" {
  type = string
}

variable "subnet" {
  type = string
}

variable "az" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami" {
  type = string
}

variable "public_key" {
  type = string
}

variable "sgs" {
  type = list(string)
}
