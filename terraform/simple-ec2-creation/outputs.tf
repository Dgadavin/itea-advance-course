output "InstancePublicIP" {
  value = aws_instance.web.public_ip
}


output "test_env_var" {
  value = var.test_env_var
}