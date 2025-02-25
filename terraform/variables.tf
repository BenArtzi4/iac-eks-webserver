variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "my-eks-cluster"
}

# VPC CIDR range
variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

# Subnet CIDRs
variable "public_subnet_1_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

# List of Availability Zones to use
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
