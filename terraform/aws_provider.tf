############################################
# AWS Provider
############################################

provider "aws" {
  region = var.aws_region
}

# Get EKS Cluster Authentication Token
data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}
