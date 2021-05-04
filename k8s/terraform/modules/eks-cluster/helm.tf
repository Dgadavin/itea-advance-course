provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

data "template_file" "traefik-values-ext" {
  template = file("../../templates/traefik_nlb_external_values.yaml")
  vars = {
    env = var.environment
  }
}


resource "helm_release" "traefik-ext" {
  name       = "traefik-ext"
  repository = "https://containous.github.io/traefik-helm-chart"
  chart      = "traefik"
  version    = "9.1.0"

  values = [
    data.template_file.traefik-values-ext.rendered
  ]
}
