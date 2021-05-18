module "iam_assumable_role_jenkins" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  create_role                   = true
  role_name                     = "${var.appname}-${var.environment}"
  provider_url                  = replace(local.oidc_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.jenkins.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:jenkins-${var.environment}:jenkins"]
}

resource "aws_iam_policy" "jenkins" {
  name_prefix = "eks-jenkins"
  description = "EKS jenkins policy"
  policy      = data.aws_iam_policy_document.jenkins.json
}

data "aws_iam_policy_document" "jenkins" {
  version = "2012-10-17"
  statement {
    sid    = "GetParameter"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid    = "AllowECR"
    effect = "Allow"
    actions = [
      "ecr:*"
    ]
    resources = [
      "*"
    ]
  }
}
