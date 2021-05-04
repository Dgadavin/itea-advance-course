data "aws_iam_policy_document" "get-parameter" {
  statement {
    sid = "1"

    actions = [
      "ssm:GetParameter"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "ssm-read-only" {
  name        = "${local.service_naming_convention}-ssm-policy"
  path        = "/"
  description = "Read-only SSM get parameter for EKS workers"
  policy      = data.aws_iam_policy_document.get-parameter.json
}

resource "aws_iam_openid_connect_provider" "oidc-provider" {
  count = var.oidc_enabled == true ? 1 : 0
  url   = module.eks.cluster_oidc_issuer_url

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [var.oidc_thumbprint]
}
