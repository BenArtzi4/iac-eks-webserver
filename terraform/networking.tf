##################################################
# Additional Networking Resources: NAT & Private Subnets
##################################################

# Declares a new AWS Elastic IP resource to the NAT Gateway
resource "aws_eip" "nat" {
  vpc = true

  depends_on = [
    aws_internet_gateway.this
  ]
}

# Create a NAT Gateway resource in one of the public subnets
# Allows private subnet instances to access the internet for outbound communication without exposing them directly.
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet_1.id

  depends_on = [
    aws_eip.nat
  ]

  tags = {
    Name = "my-eks-nat-gw"
  }
}

# Create 2 Private Subnets in different AZs
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block             = var.private_subnet_1_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "my-eks-private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block             = var.private_subnet_2_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "my-eks-private-subnet-2"
  }
}

# Create a separate route table for private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "my-eks-private-rt"
  }
}

# Route private traffic to the NAT Gateway for internet access
resource "aws_route" "private_internet_access" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id

  depends_on = [
    aws_nat_gateway.this
  ]
}

# Associate each private subnet with the private route table
resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_subnet_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private.id
}
