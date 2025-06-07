# Terraform main configuration file

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Specify a version constraint
    }
  }
}

provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
  # You can also configure credentials here, or via environment variables,
  # shared credentials file, or IAM roles.
  # access_key = "YOUR_ACCESS_KEY"
  # secret_key = "YOUR_SECRET_KEY"
}

# Terraform Backend Configuration (Optional - S3 Example)
# Commented out for now, uses local backend by default.
#
# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket-name" # Replace with your S3 bucket name
#     key            = "project-name/terraform.tfstate"   # Replace with your state file path
#     region         = "us-east-1"                        # Replace with your S3 bucket region
#     # dynamodb_table = "your-terraform-locks-table"      # Optional: For state locking
#     # encrypt        = true                               # Optional: Enable server-side encryption
#   }
# }

# --- Networking ---

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

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

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Public Subnet Associations to Route Table
resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public.id
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat_az1" {
  domain   = "vpc" # Changed from 'vpc = true' to 'domain = "vpc"' for AWS provider v4.x+
  tags = {
    Name = "${var.project_name}-nat-eip-az1"
  }
}

resource "aws_eip" "nat_az2" {
  domain   = "vpc" # Changed from 'vpc = true' to 'domain = "vpc"' for AWS provider v4.x+
  tags = {
    Name = "${var.project_name}-nat-eip-az2"
  }
}

# NAT Gateways
resource "aws_nat_gateway" "nat_az1" {
  allocation_id = aws_eip.nat_az1.id
  subnet_id     = aws_subnet.public_az1.id # NAT Gateway resides in a public subnet

  tags = {
    Name = "${var.project_name}-nat-gw-az1"
  }

  # Ensure IGW is created before NAT gateway
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "nat_az2" {
  allocation_id = aws_eip.nat_az2.id
  subnet_id     = aws_subnet.public_az2.id # NAT Gateway resides in a public subnet

  tags = {
    Name = "${var.project_name}-nat-gw-az2"
  }

  # Ensure IGW is created before NAT gateway
  depends_on = [aws_internet_gateway.gw]
}

# Route Table for Private Subnet AZ1
resource "aws_route_table" "private_az1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_az1.id
  }

  tags = {
    Name = "${var.project_name}-private-rt-az1"
  }
}

# Route Table for Private Subnet AZ2
resource "aws_route_table" "private_az2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_az2.id
  }

  tags = {
    Name = "${var.project_name}-private-rt-az2"
  }
}

# Private Subnet Associations to Route Tables
resource "aws_route_table_association" "private_az1" {
  subnet_id      = aws_subnet.private_az1.id
  route_table_id = aws_route_table.private_az1.id
}

resource "aws_route_table_association" "private_az2" {
  subnet_id      = aws_subnet.private_az2.id
  route_table_id = aws_route_table.private_az2.id
}

# Security Group for Application Load Balancer
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for the ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTPS from anywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # All protocols
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

# Security Group for EC2 Instances
resource "aws_security_group" "ec2_instance" {
  name        = "${var.project_name}-ec2-sg"
  description = "Security group for the EC2 instances"
  vpc_id      = aws_vpc.main.id

  # Ingress rule for application traffic from ALB
  ingress {
    description     = "App traffic from ALB"
    from_port       = 3000 # Assuming app runs on port 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id] # Only allow traffic from the ALB
  }

  # Ingress rule for SSH
  ingress {
    description      = "SSH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip_for_ssh]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # All protocols
    cidr_blocks      = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

# --- ECR ---

resource "aws_ecr_repository" "app" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE" # or "IMMUTABLE" if you prefer

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name      = "${var.project_name}-ecr-${var.ecr_repository_name}"
    Project   = var.project_name
  }
}
