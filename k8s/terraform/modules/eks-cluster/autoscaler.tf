# module "iam_assumable_role_admin" {
#   source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
#   create_role                   = true
#   role_name                     = "${var.appname}-autoscaler-${var.environment}"
#   provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
#   role_policy_arns              = [aws_iam_policy.cluster_autoscaler.arn]
#   oidc_fully_qualified_subjects = ["system:serviceaccount:default:cluster-autoscaler-aws-cluster-autoscaler"]
# }
#
# resource "aws_iam_policy" "cluster_autoscaler" {
#   name_prefix = "cluster-autoscaler"
#   description = "EKS cluster-autoscaler policy for cluster ${module.eks.cluster_id}"
#   policy      = data.aws_iam_policy_document.cluster_autoscaler.json
# }
#
# data "aws_iam_policy_document" "cluster_autoscaler" {
#   statement {
#     sid    = "clusterAutoscalerAll"
#     effect = "Allow"
#
#     actions = [
#       "autoscaling:DescribeAutoScalingGroups",
#       "autoscaling:DescribeAutoScalingInstances",
#       "autoscaling:DescribeLaunchConfigurations",
#       "autoscaling:DescribeTags",
#       "ec2:DescribeLaunchTemplateVersions",
#     ]
#
#     resources = ["*"]
#   }
#
#   statement {
#     sid    = "clusterAutoscalerOwn"
#     effect = "Allow"
#
#     actions = [
#       "autoscaling:SetDesiredCapacity",
#       "autoscaling:TerminateInstanceInAutoScalingGroup",
#       "autoscaling:UpdateAutoScalingGroup",
#     ]
#
#     resources = ["*"]
#
#     condition {
#       test     = "StringEquals"
#       variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${module.eks.cluster_id}"
#       values   = ["owned"]
#     }
#
#     condition {
#       test     = "StringEquals"
#       variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
#       values   = ["true"]
#     }
#   }
# }
#
# data "template_file" "autoscaler-values" {
#   template = file("../../templates/autoscaler_values.yaml")
#   vars = {
#     aws_region       = var.aws_region
#     role_arn         = module.iam_assumable_role_admin.this_iam_role_arn
#     eks_cluster_name = local.service_naming_convention
#   }
# }
#
# resource "helm_release" "cluster-autoscaler" {
#   name       = "cluster-autoscaler"
#   chart      = "cluster-autoscaler"
#   repository = "https://kubernetes.github.io/autoscaler"
#   values = [
#     data.template_file.autoscaler-values.rendered
#   ]
# }
#
# resource "helm_release" "termination-handler" {
#   name       = "termination-handler"
#   repository = "https://charts.helm.sh/stable"
#   chart      = "k8s-spot-termination-handler"
#   values = [
#     file("../../templates/termination_handler_values.yaml")
#   ]
# }
