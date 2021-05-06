module "eks-cluster" {
  source = "../../../../modules/eks-cluster"

  environment       = "dev"
  aws_acccount_name = "itea"
  aws_region        = "eu-west-1"
  appname           = "eks-cluster"

  hosted_zone_name        = "itea.devopsology.org"
  domain_zone_id          = "Z001828634P7CJAKA3JL6"
  certificate_domain_name = "*.itea.devopsology.org"

  eks_cluster_cidr             = "10.1.0.0/16"
  azs                          = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  eks_cluster_public_subnets   = ["10.1.48.0/24", "10.1.49.0/24", "10.1.50.0/24"]
  eks_cluster_private_subnets  = ["10.1.0.0/20", "10.1.16.0/20", "10.1.32.0/20"]
  eks_cluster_database_subnets = ["10.1.51.0/24", "10.1.52.0/24", "10.1.53.0/24"]

  worker_instance_type                     = ["t3.medium"]
  asg_min_size                             = 2
  asg_max_size                             = 4
  asg_desired_capacity                     = 2
  on_demand_base_capacity                  = 0
  on_demand_percentage_above_base_capacity = 0
  spot_instance_pools                      = 10
  spot_price                               = "0.015"


  # es_version        = "7.1"
  # es_instance_type  = "t3.medium.elasticsearch"
  # es_volume_size    = 50
  # es_instance_count = 1

  map_users = [
    {
      userarn  = "arn:aws:iam::438378284830:user/sotnikov-admin"
      username = "sotnikov_admin"
      groups   = ["system:masters"]
    },
  ]

  oidc_enabled    = true
  oidc_thumbprint = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"

}
