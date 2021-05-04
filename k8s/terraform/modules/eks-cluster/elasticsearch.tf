# variable "es_version" {
#   description = "ES version"
#   default     = "7.1"
#   type        = string
# }
#
# variable "es_instance_type" {
#   description = "ES instance type"
#   default     = "t3.medium.elasticsearch"
#   type        = string
# }
#
# variable "es_volume_size" {
#   description = "ES EBS volume size"
#   default     = 50
# }
#
# variable "es_instance_count" {
#   description = "Number of instances in cluster"
#   default     = 1
# }
#
# variable "create_iam_service_linked_role" {
#   description = "create iam service linked role"
#   default     = false
# }
#
# module "elk_sg" {
#   source  = "terraform-aws-modules/security-group/aws"
#   version = "3.4.0"
#   name    = "${local.service_naming_convention}-elk"
#   vpc_id  = module.vpc.vpc_id
#
#   ingress_with_cidr_blocks = [
#     {
#       from_port   = 443
#       to_port     = 443
#       protocol    = "tcp"
#       cidr_blocks = join(",", data.terraform_remote_state.base.outputs.eks_cluster_private_subnets_cidr_blocks)
#     }
#   ]
#
#   ingress_with_source_security_group_id = [
#     {
#       from_port                = 443
#       to_port                  = 443
#       protocol                 = "tcp"
#       source_security_group_id = module.worker_sg.this_security_group_id
#     }
#   ]
#
#   egress_with_cidr_blocks = [
#     {
#       from_port   = -1
#       to_port     = -1
#       protocol    = -1
#       cidr_blocks = "0.0.0.0/0"
#     },
#   ]
#
#   tags = {
#     Name        = "${local.service_naming_convention}-elk"
#     Application = var.appname
#     Role        = "ELK"
#     Environment = var.environment
#     Description = "ElasticSearch security group"
#     Terraform   = "true"
#   }
# }
#
# module "es" {
#   source = "git::https://github.com/terraform-community-modules/tf_aws_elasticsearch.git"
#
#   domain_name = "${local.service_naming_convention}-logging"
#   es_version  = var.es_version
#   vpc_options = {
#     security_group_ids = [module.elk_sg.this_security_group_id]
#     subnet_ids         = [module.vpc.private_subnets[0]]
#   }
#   instance_count    = var.es_instance_count
#   instance_type     = var.es_instance_type
#   es_zone_awareness = false
#   ebs_volume_size   = var.es_volume_size
#   advanced_options = {
#     "rest.action.multi.allow_explicit_index" = "true" # double quotes are required here
#   }
#
#   tags = {
#     Name        = "${local.service_naming_convention}-elk"
#     Application = var.appname
#     Role        = "ELK"
#     Environment = var.environment
#     Description = "ElasticSearch domain"
#     Terraform   = "true"
#   }
# }
#
# module "es-cleanup" {
#   source       = "anonfriese/es-cleanup/aws"
#   version      = "1.13.3"
#   es_endpoint  = module.es.endpoint
#   subnet_ids   = module.vpc.private_subnets
#   delete_after = 5
#   suffix       = "-${var.environment}"
#
#   tags = {
#     Name        = "${local.service_naming_convention}-es-cleanup"
#     Application = var.appname
#     Role        = "ELK"
#     Environment = var.environment
#     Description = "Lambda cleanup old indexes"
#     Terraform   = "true"
#   }
# }
