data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
 tags = {
   Name = "nginx-vpc"
 }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {Name = "nginx-igw"}
}

resource "aws_subnet" "public" {
  count = 2
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "nginx-public-subnet-${count.index}"
  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = {Name ="nginx-public-rt"}
}
resource "aws_route" "internet_access" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}
resource "aws_route_table_association" "public_assoc" {
  count = 2
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}