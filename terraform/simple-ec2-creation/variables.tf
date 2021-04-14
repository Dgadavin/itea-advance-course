variable "ami_id" {
  default = "ami-00eb20669e0990cb4"
}

variable "aws_region" {
  default = "eu-west-1"
}

variable "subnet_id" {
}

variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_id" {
}

variable "environment" {
  default = "dev"
}