##################################################
# IAM for EKS Control Plane
##################################################

# Creates a policy for the EKS service
data "aws_iam_policy_document" "eks_cluster_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

# Defines an IAM role for the EKS cluster
resource "aws_iam_role" "eks_cluster_role" {
  name               = "eksClusterRole"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role_policy.json
}

# Attaches the AmazonEKSClusterPolicy to the EKS cluster role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# Attaches the AmazonEKSServicePolicy to the role for permissions required by EKS
resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

##################################################
# IAM Role for Worker Nodes (Allows EC2 Instances to assume this role)
##################################################

data "aws_iam_policy_document" "eks_node_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Defines an IAM role for the EKS worker nodes
resource "aws_iam_role" "node_group_role" {
  name               = "eksNodeRole"
  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role_policy.json
}

# Attaches the AmazonEKSWorkerNodePolicy to allow worker nodes to join the EKS cluster
resource "aws_iam_role_policy_attachment" "node_group_attach1" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Attaches the AmazonEC2ContainerRegistryReadOnly policy to allow worker nodes to pull images from Amazon ECR
resource "aws_iam_role_policy_attachment" "node_group_attach2" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
