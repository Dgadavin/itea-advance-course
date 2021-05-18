data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_name
}

data "aws_eks_cluster" "cluster" {
  name = local.cluster_name
}

data "aws_ssm_parameter" "jenkins_deploy_key" {
  name = "/jenkins/dev/deploy_key"
}

provider "helm" {
  kubernetes {
    token                  = data.aws_eks_cluster_auth.cluster.token
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  }
}

data "template_file" "jenkins-values" {
  template = file("./templates/jenkins_values.yml")
  vars = {
    env                 = var.environment
    hosted_zone         = var.hosted_zone
    cluster             = local.cluster_name
    jenkins_role_arn    = module.iam_assumable_role_jenkins.iam_role_arn
    deployer_privat_key = indent(24, data.aws_ssm_parameter.jenkins_deploy_key.value)
  }
}

resource "helm_release" "jenkins" {
  depends_on    = [kubernetes_namespace.jenkins]
  name          = "jenkins"
  repository    = "https://charts.jenkins.io"
  chart         = "jenkins"
  version       = "3.1.8"
  namespace     = "jenkins-${var.environment}"
  reset_values  = true
  recreate_pods = true
  values = [
    data.template_file.jenkins-values.rendered
  ]
}
