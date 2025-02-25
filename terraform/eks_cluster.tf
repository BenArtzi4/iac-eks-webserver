##################################################
# EKS Cluster
##################################################

# Declares a new Terraform resource 
resource "aws_eks_cluster" "this" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  # Defines the VPC networking configuration for the EKS cluster
  vpc_config {
    subnet_ids = [
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id
    ]
  }

  # Ensures that Terraform creates and attaches the required IAM policies before creating the EKS cluster
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_service_policy
  ]
}
