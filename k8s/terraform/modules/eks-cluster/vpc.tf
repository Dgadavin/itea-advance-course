module "vpc" {
  source           = "terraform-aws-modules/vpc/aws"
  version          = "2.64.0"
  name             = local.service_naming_convention
  cidr             = var.eks_cluster_cidr
  azs              = var.azs
  private_subnets  = var.eks_cluster_private_subnets
  public_subnets   = var.eks_cluster_public_subnets
  database_subnets = var.eks_cluster_database_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/eks-cluster-${var.environment}" = "shared"
    "kubernetes.io/role/elb"                               = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/eks-cluster-${var.environment}" = "shared"
    "kubernetes.io/role/internal-elb"                      = "1"
  }

  tags = {
    Name        = "${local.service_naming_convention}-vpc"
    Application = var.appname
    Role        = "VPC"
    Environment = var.environment
    Terraform   = "true"
  }
}
