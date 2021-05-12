variable "ansible_hosts" {
  type = list(string)
  default = [
    "ansible-01",
    "ansible-02"
  ]
}

variable "key_name" {}

variable "ami_id" {
  default = "ami-07d9160fa81ccffb5"
}

variable "vpc_id" {}

resource "aws_instance" "ansible" {
  for_each                    = toset(var.ansible_hosts)
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.devopsology-infra.id]
  associate_public_ip_address = true

  tags = {
    Name = each.key
  }
}
