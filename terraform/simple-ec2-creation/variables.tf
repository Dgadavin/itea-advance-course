variable "ami_id" {
  default = "ami-0ffea00000f287d30"
  description = "Amazon Linux 2 ami id"
}

variable "aws_region" {
  default = "eu-west-1"
}

//variable "subnet_id" {
//}

variable "instance_type" {
  default = "t2.micro"
}

//variable "vpc_id" {
//}

variable "environment" {
  default = "dev"
}

variable "test_env_var" {}

//variable "ami_id" {
//  type = "map"
//  default = {
//    "eu-swest-1": "ami-00eb20669e0990cb4",
//    "us-east-1": "ami-00eb20669e0990cb1"
//  }
//}