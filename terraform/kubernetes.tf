provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

resource "kubernetes_namespace" "project_ns" {
  metadata {
    name = "webserver-namespace"
  }
}

resource "kubernetes_service_account" "project_sa" {
  metadata {
    name      = "webserver-service-account"
    namespace = kubernetes_namespace.project_ns.metadata[0].name
  }
}
