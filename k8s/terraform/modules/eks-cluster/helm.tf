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
    certificate_arn  = aws_acm_certificate.project_cert.arn
    hosted_zone_name = var.hosted_zone_name
    env              = var.environment
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

data "template_file" "argo-values" {
  template = file("../../templates/argocd_values.yaml")
  vars = {
    account_name     = var.aws_acccount_name
    hosted_zone_name = var.hosted_zone_name
    env              = var.environment
  }
}

resource "helm_release" "argocd-app" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  values = [
    data.template_file.argo-values.rendered
  ]
}

data "template_file" "fluentd-values" {
  template = file("../../templates/es_fluentd_values.yaml")
  vars = {
    aws_es_hostname = module.es.endpoint
  }
}

resource "helm_release" "fluentd" {
  depends_on = [module.es]
  name       = "fluentd-logging"
  chart      = "fluentd-elasticsearch"
  repository = "https://kiwigrid.github.io"
  version    = "6.2.3"
  values = [
    data.template_file.fluentd-values.rendered
  ]
}

data "template_file" "external-dns-values" {
  template = file("../../templates/external_dns_values.yaml")
  vars = {
  }
}

resource "helm_release" "external-dns" {
  name       = "external-dns"
  chart      = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "4.9.4"
  values = [
    data.template_file.external-dns-values.rendered
  ]
}

resource "helm_release" "k8s-aws-secrets" {
  name       = "k8s-secrets"
  chart      = "kubernetes-external-secrets"
  repository = "https://external-secrets.github.io/kubernetes-external-secrets/"
  version    = "3.2.0"

  set {
    name  = "env.AWS_REGION"
    value = var.aws_region
  }
  set {
    name  = "env.POLLER_INTERVAL_MILLISECONDS"
    value = "100000"
  }
}

resource "helm_release" "metrics-server" {
  name       = "metrics-server"
  chart      = "metrics-server"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "5.5.1"
  set {
    name  = "apiService.create"
    value = true
  }
}
