variable "worker_instance_type" {
  description = "Instance type for workers"
  default     = ["t3.medium"]
}

variable "asg_min_size" {
  description = "Min size of workers ASG"
  default     = "2"
}

variable "asg_desired_capacity" {
  description = "Desired capacity for workers ASG"
  default     = "2"
}

variable "asg_max_size" {
  description = "Max size of workers ASG"
  default     = "2"
}

variable "on_demand_base_capacity" {
  description = "Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances"
  default     = "0"
}

variable "on_demand_percentage_above_base_capacity" {
  description = "Percentage split between on-demand and Spot instances above the base on-demand capacity"
  default     = "0"
}

variable "spot_instance_pools" {
  description = "Number of Spot pools per availability zone to allocate capacity. EC2 Auto Scaling selects the cheapest Spot pools and evenly allocates Spot capacity across the number of Spot pools that you specify."
  default     = "10"
}

variable "spot_allocation_strategy" {
  description = "Valid options are 'lowest-price' and 'capacity-optimized'. If 'lowest-price', the Auto Scaling group launches instances using the Spot pools with the lowest price, and evenly allocates your instances across the number of Spot pools. If 'capacity-optimized', the Auto Scaling group launches instances using Spot pools that are optimally chosen based on the available Spot capacity."
  default     = "lowest-price"
}

variable "spot_price" {
  description = "Price for spot instances"
  default     = "0.02"
}

variable "aws_acccount_name" {
  description = "AWS account name"
}

variable "write_kubeconfig" {
  description = "Whether to write a Kubectl config file containing the cluster configuration."
  default     = false
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "eks" {
  source           = "terraform-aws-modules/eks/aws"
  version          = "14.0.0"
  cluster_name     = local.service_naming_convention
  cluster_version  = "1.18"
  subnets          = module.vpc.private_subnets
  vpc_id           = module.vpc.vpc_id
  write_kubeconfig = var.write_kubeconfig

  tags = {
    Name        = "${local.service_naming_convention}-eks"
    Application = var.appname
    Role        = "EKS"
    Environment = var.environment
    Terraform   = "true"
  }

  workers_additional_policies = ["arn:aws:iam::aws:policy/AmazonRoute53FullAccess", aws_iam_policy.ssm-read-only.arn]

  worker_groups_launch_template = [{
    override_instance_types = var.worker_instance_type
    root_encrypted          = true
    root_volume_size        = 30

    asg_min_size                             = var.asg_min_size
    asg_max_size                             = var.asg_max_size
    asg_desired_capacity                     = var.asg_desired_capacity
    on_demand_base_capacity                  = var.on_demand_base_capacity
    on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
    spot_instance_pools                      = var.spot_instance_pools
    spot_max_price                           = var.spot_price

    key_name = aws_key_pair.generated_key.key_name
    subnets  = module.vpc.private_subnets

    kubelet_extra_args = "--node-labels=node.kubernetes.io/lifecycle=`curl -s http://169.254.169.254/latest/meta-data/instance-life-cycle`"

    suspended_processes    = ["AZRebalance"]
    asg_recreate_on_change = true
    enabled_metrics        = var.enabled_metrics
    subnets                = module.vpc.private_subnets
    tags = [
      {
        "key"                 = "k8s.io/cluster-autoscaler/enabled"
        "propagate_at_launch" = "false"
        "value"               = "true"
      },
      {
        "key"                 = "k8s.io/cluster-autoscaler/${local.service_naming_convention}-eks"
        "propagate_at_launch" = "false"
        "value"               = "true"
      }
    ]
  }]
  map_users = var.map_users
}
