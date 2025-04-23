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

# Creating route table with NAT for private subnets
resource "aws_route_table" "private" {
  count = var.nat_count > 0 ? length(var.private_subnet_cidr) : 0
  
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0" # Destination: route all IPv4 traffic (default route)
    gateway_id = aws_nat_gateway.nat[count.index % var.nat_count].id # Target: use the NAT Gateway as the target. It makes it only outgoing.
  }

  tags = {
    "Name" = "${var.vpc_name}-rt-private${count.index + 1}-${var.availability_zone[count.index]}"
    "Env" = var.env
  }

  depends_on = [ aws_internet_gateway.igw ]
}

# Attaching NAT route table for subnets
resource "aws_route_table_association" "pivate_association" {
    count = length(var.private_subnet_cidr)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private[count.index].id
}