# Module: NAT Gateway resources

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
