provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket  = "sotnikov-itea-tf-states"
    key     = "dev/jenkins/terraform.state"
    region  = "eu-west-1"
    encrypt = true
    acl     = "bucket-owner-full-control"
  }
  required_providers {
    kubernetes-alpha = "0.2.1"
  }
}
