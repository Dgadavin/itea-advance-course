module "base_setup" {
  source               = "../modules/base_aws_setup"
  vpc_cidr_range_dev   = var.vpc_cidr_range_dev
  vpc_cidr_range_stage = var.vpc_cidr_range_stage
  short_name           = var.short_name
  subnet_public_dev    = var.subnet_public_dev
  subnet_public_stage  = var.subnet_public_stage
}