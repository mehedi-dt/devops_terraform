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

# resource "aws_route_table" "private" {
#     vpc_id = aws_vpc.vpc.id

#     tags = {
#       Name = "${var.vpc_name}-private-rt"
#     }
# }