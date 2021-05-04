resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 8097
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${local.service_naming_convention}-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_ssm_parameter" "ssh_key" {
  name  = "/${var.appname}/${var.environment}/ec2_ssh_private_key"
  type  = "SecureString"
  tier  = "Advanced"
  value = tls_private_key.ssh_key.private_key_pem
}
