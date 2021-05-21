data "terraform_remote_state" "eks-cluster" {
  backend = "s3"
  config = {
    bucket = "sotnikov-itea-tf-states"
    key    = "dev/eks-cluster/terraform.state"
    region = "eu-west-1"
  }
}

locals {
  cluster_name = data.terraform_remote_state.eks-cluster.outputs.eks_cluster_name
}
