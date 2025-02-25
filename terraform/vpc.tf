############################################
# Creates VPC, Subnets, and Basic Networking
############################################

# Create the VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "my-eks-vpc"
  }
}

# Internet Gateway - Path for internet traffic
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "my-eks-igw"
  }
}

# Public route table - Define the routes
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "my-eks-public-rt"
  }
}

# Add a route to the internet - Sends external (non-VPC) traffic to the internet
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Create two public subnets across different availability zones
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block             = var.public_subnet_1_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "my-eks-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block             = var.public_subnet_2_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "my-eks-public-subnet-2"
  }
}

# Linking each subnet to the public route table
resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}
