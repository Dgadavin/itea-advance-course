# output "kibana-endpoint" {
#   value = module.eks-cluster.kibana-endpoint
# }
#
# output "es_endpoint" {
#   value = module.eks-cluster.es_endpoint
# }
#
# output "es_sg_id" {
#   value = module.eks-cluster.es_sg_id
# }

output "eks_worker_sg" {
  value = module.eks-cluster.eks_worker_sg
}

output "eks_cluster_name" {
  value = module.eks-cluster.eks_cluster_name
}

output "workers_asg_names" {
  value = module.eks-cluster.workers_asg_names
}

output "oidc_provider_arn" {
  value = join(" ", module.eks-cluster.oidc_provider_arn.*)
}

output "oidc_provider_url" {
  value = module.eks-cluster.oidc_provider_url
}
