# output "kibana-endpoint" {
#   value = module.es.kibana_endpoint
# }
#
# output "es_endpoint" {
#   value = module.es.endpoint
# }
#
# output "es_sg_id" {
#   value = module.elk_sg.this_security_group_id
# }

output "eks_worker_sg" {
  value = module.eks.worker_security_group_id
}

output "eks_cluster_name" {
  value = local.service_naming_convention
}

output "workers_asg_names" {
  value = module.eks.workers_asg_names
}

output "oidc_provider_arn" {
  value = join(" ", aws_iam_openid_connect_provider.oidc-provider.*.arn)
}

output "oidc_provider_url" {
  value = module.eks.cluster_oidc_issuer_url
}
