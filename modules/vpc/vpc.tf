resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Публічні підмережі
resource "aws_subnet" "public" {
  for_each = {
    a = { cidr = var.public_subnets[0], az = var.availability_zones[0] }
    b = { cidr = var.public_subnets[1], az = var.availability_zones[1] }
    c = { cidr = var.public_subnets[2], az = var.availability_zones[2] }
  }
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-${each.key}"
  }
}

# Приватні підмережі
resource "aws_subnet" "private" {
  for_each = {
    a = { cidr = var.private_subnets[0], az = var.availability_zones[0] }
    b = { cidr = var.private_subnets[1], az = var.availability_zones[1] }
    c = { cidr = var.private_subnets[2], az = var.availability_zones[2] }
  }
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${var.vpc_name}-private-${each.key}"
  }
}

# Elastic IP для NAT
resource "aws_eip" "nat" {
  for_each = aws_subnet.public
  domain   = "vpc"
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.vpc_name}-eip-${each.key}"
  }
}

# NAT Gateways
resource "aws_nat_gateway" "nat" {
  for_each      = aws_subnet.public
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.vpc_name}-nat-${each.key}"
  }
}
