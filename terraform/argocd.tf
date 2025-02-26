##################################################
# Install ArgoCD in EKS using Helm
##################################################

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.this.endpoint
    token                  = data.aws_eks_cluster_auth.this.token
    cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
  }
}

# # Ensure ArgoCD Namespace is Created Only After EKS is Ready
# resource "kubernetes_namespace" "argocd" {
#   metadata {
#     name = "argocd"
#   }

#   depends_on = [aws_eks_node_group.this]  # Ensures worker nodes are ready before running
# }

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"  # Use existing namespace

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}
