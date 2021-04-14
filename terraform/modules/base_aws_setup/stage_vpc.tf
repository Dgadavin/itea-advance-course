resource "aws_vpc" "stage_vpc" {
  cidr_block           = var.vpc_cidr_range_stage
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.short_name}-vpc-stage"
    Stack       = "main"
    Environment = "stage"
  }
}

#Create private subnets
resource "aws_subnet" "public_stage" {
  count                   = length(var.subnet_public_stage)
  vpc_id                  = aws_vpc.stage_vpc.id
  cidr_block              = element(values(var.subnet_public_stage), count.index)
  availability_zone       = element(keys(var.subnet_public_stage), count.index)
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.short_name}-public-subnet-stage"
    Stack       = "main"
    Environment = "stage"
  }
}

resource "aws_internet_gateway" "igw_stage" {
  vpc_id = aws_vpc.stage_vpc.id
  tags = {
    Name        = "${var.short_name}-igw-stage"
    Stack       = "main"
    Environment = "stage"
  }
}

resource "aws_route_table" "public_rt_stage" {
  vpc_id = aws_vpc.stage_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_stage.id
  }
  lifecycle {
    ignore_changes = [route]
  }
  tags = {
    Name        = "${var.short_name}-public-rt-stage"
    Stack       = "main"
    Environment = "stage"
  }
}

resource "aws_route_table_association" "public_rt_assosiation_stage" {
  count          = length(var.subnet_public_stage)
  subnet_id      = element(aws_subnet.public_stage.*.id, count.index)
  route_table_id = aws_route_table.public_rt_stage.id
}

