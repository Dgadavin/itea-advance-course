resource "aws_vpc" "dev_vpc" {
  cidr_block           = var.vpc_cidr_range_dev
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.short_name}-vpc-dev"
    Stack       = "main"
    Environment = "dev"
  }
}

resource "aws_subnet" "public_dev" {
  count                   = length(var.subnet_public_dev)
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = element(values(var.subnet_public_dev), count.index)
  availability_zone       = element(keys(var.subnet_public_dev), count.index)
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.short_name}-public-subnet-dev"
    Stack       = "main"
    Environment = "dev"
  }
}

resource "aws_internet_gateway" "igw_dev" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name        = "${var.short_name}-igw-dev"
    Stack       = "main"
    Environment = "dev"
  }
}

resource "aws_route_table" "public_rt_dev" {
  vpc_id = aws_vpc.dev_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_dev.id
  }
  lifecycle {
    ignore_changes = [route]
  }
  tags = {
    Name        = "${var.short_name}-public-rt-dev"
    Stack       = "main"
    Environment = "dev"
  }
}

resource "aws_route_table_association" "public_rt_assosiation_dev" {
  count          = length(var.subnet_public_dev)
  subnet_id      = element(aws_subnet.public_dev.*.id, count.index)
  route_table_id = aws_route_table.public_rt_dev.id
}

