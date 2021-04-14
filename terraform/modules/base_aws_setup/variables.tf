variable "vpc_cidr_range_dev" {
}

variable "vpc_cidr_range_stage" {
}

variable "subnet_public_dev" {
  type = map(string)
}

variable "subnet_public_stage" {
  type = map(string)
}

variable "region" {
  default = "eu-west-1"
}

variable "short_name" {
  default = "itea"
}
