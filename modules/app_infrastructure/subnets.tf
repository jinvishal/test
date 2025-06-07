# Module: Subnet resources

# Public Subnets
resource "aws_subnet" "public_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_az1_cidr_block
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true # Instances launched in this subnet should get a public IP

  tags = {
    Name = "${var.project_name}-public-subnet-az1"
  }
}

resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_az2_cidr_block
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-az2"
  }
}

# Private Subnets
resource "aws_subnet" "private_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_az1_cidr_block
  availability_zone       = var.availability_zones[0]

  tags = {
    Name = "${var.project_name}-private-subnet-az1"
  }
}

resource "aws_subnet" "private_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_az2_cidr_block
  availability_zone       = var.availability_zones[1]

  tags = {
    Name = "${var.project_name}-private-subnet-az2"
  }
}
