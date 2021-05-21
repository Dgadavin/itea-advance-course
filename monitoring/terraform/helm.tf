data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_name
}

data "aws_eks_cluster" "cluster" {
  name = local.cluster_name
}

provider "helm" {
  kubernetes {
    token                  = data.aws_eks_cluster_auth.cluster.token
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  }
}

data "template_file" "prometheus-values" {
  template = file("./templates/prometheus_values.yaml")
  vars = {
    env              = var.environment
    hosted_zone_name = var.hosted_zone
    cluster          = local.cluster_name
  }
}

resource "helm_release" "prometheus" {
  name          = "prometheus-operator"
  repository    = "https://prometheus-community.github.io/helm-charts"
  chart         = "kube-prometheus-stack"
  version       = "12.10.6"
  namespace     = "monitoring"
  reset_values  = true
  recreate_pods = true
  values = [
    data.template_file.prometheus-values.rendered
  ]
}
