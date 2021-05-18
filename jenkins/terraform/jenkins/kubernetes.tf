provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "kubernetes-alpha" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  server_side_planning   = true
}

resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins-${var.environment}"
  }
}

resource "kubernetes_manifest" "requestheaders-https" {
  provider = kubernetes-alpha
  manifest = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "Middleware"
    metadata = {
      name      = "requestheaders-https"
      namespace = "default"
    }
    spec = {
      headers = {
        customRequestHeaders = {
          X-Forwarded-Port  = "443"
          X-Forwarded-Proto = "https"
        }
      }
    }
  }
}
