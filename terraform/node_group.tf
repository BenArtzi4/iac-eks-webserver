##################################################
# EKS Node Group (Worker Nodes)
##################################################

# Create the EKS Node Group
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "my-eks-nodes"
  node_role_arn   = aws_iam_role.node_group_role.arn  # Moved IAM role definition to iam_control_plane.tf

  subnet_ids = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_group_attach1,
    aws_iam_role_policy_attachment.node_group_attach2
  ]
}
