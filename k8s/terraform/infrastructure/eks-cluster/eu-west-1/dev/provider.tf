terraform {
  backend "s3" {
    bucket  = "sotnikov-itea-tf-states"
    key     = "dev/eks-cluster/terraform.state"
    region  = "eu-west-1"
    encrypt = true
    acl     = "bucket-owner-full-control"
  }

  required_version = "~> 0.14"
  required_providers {
    aws        = "3.28.0"
    kubernetes = "2.0.2"
    helm       = "2.0.2"
  }
}

provider "aws" {
  region = "eu-west-1"
}
