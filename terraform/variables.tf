##################################################
# Variables for AWS Region & EKS Cluster
##################################################

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "my-eks-cluster"
}

##################################################
# Variables for VPC & Subnets
##################################################

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {  # 🔹 Missing variable added
  type    = string
  default = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {  # 🔹 Missing variable added
  type    = string
  default = "10.0.4.0/24"
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

##################################################
# Variables for EKS Node Group
##################################################

variable "node_group_name" {  # 🔹 Missing variable added
  type    = string
  default = "my-eks-nodes"
}

variable "node_group_min_size" {  # 🔹 Missing variable added
  type    = number
  default = 1
}

variable "node_group_desired_size" {  # 🔹 Missing variable added
  type    = number
  default = 2
}

variable "node_group_max_size" {  # 🔹 Missing variable added
  type    = number
  default = 3
}
