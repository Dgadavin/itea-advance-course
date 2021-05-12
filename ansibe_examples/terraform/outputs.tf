output "instance_public_ips" {
  value = { for k, v in aws_instance.ansible : k => v.public_ip }
}
