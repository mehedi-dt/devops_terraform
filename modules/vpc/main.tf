resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support   = var.enable_dns_support
    enable_dns_hostnames = var.enable_dns_hostnames

    tags = {
        Name = "${var.vpc_name}-vpc"
        Env = var.env
    }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)

  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name = "${var.vpc_name}-public-sn-${var.availability_zone[count.index]}"
    Env = var.env
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)

  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name = "${var.vpc_name}-private-sn-${var.availability_zone[count.index]}"
    Env = var.env
  }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id

    tags = {
      Name = "${var.vpc_name}-igw"
      Env = var.env
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
      Name = "${var.vpc_name}-public-rt"
      Env = var.env
    }
}

resource "aws_route_table_association" "public_association" {
    count = length(var.public_subnet_cidr)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}

# EIP for NAT
resource "aws_eip" "eip" {
  count = var.nat_count > 0 ? var.nat_count : 0
  domain = "vpc"

  tags = {
    Name = "${var.vpc_name}-nat-${var.availability_zone[count.index]}-ip"
    Env = var.env
  }
}

# NAT
resource "aws_nat_gateway" "nat" {
  count = var.nat_count > 0 ? var.nat_count : 0
  allocation_id = aws_eip.eip[count.index].id
  subnet_id = aws_subnet.public[count.index].id # subnet where the NAT will reside.

  tags = {
      Name = "${var.vpc_name}-nat-${var.availability_zone[count.index]}"
      Env = var.env
    }
  
  depends_on = [ aws_internet_gateway.igw ]
}

# Route table for each private subnet for NAT
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-rt-private${count.index + 1}-${var.availability_zone[count.index]}"
    Env  = var.env
  }
}

# Adding routes to the private route table for NAT
resource "aws_route" "nat" {
  count                  = var.nat_count > 0 ? length(var.private_subnet_cidr) : 0
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index % var.nat_count].id
}

# Attaching NAT route table for subnets
resource "aws_route_table_association" "pivate_association" {
    count = length(var.private_subnet_cidr)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private[count.index].id
}

# S3 Gateway
resource "aws_vpc_endpoint" "s3" {
  count = var.s3_gateway ? 1 : 0

  vpc_id = aws_vpc.vpc.id
  route_table_ids = aws_route_table.private[*].id
  service_name = "com.amazonaws.${var.region}.s3" # prefix for s3 gateway from the prifix list
  vpc_endpoint_type = "Gateway"

  tags = {
    "Name" = "${var.vpc_name}-s3-endpoint"
    "Env" = var.env
  }
}