##############################
##           VPC            ##
##############################
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = var.vpc_common_tags
}

##############################
##      Public Subnet       ##
##############################
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  for_each = { for idx, cidr in var.public_cidr_blocks : idx => {
    cidr = cidr,
    az   = var.azs[idx % length(var.azs)]
  } }

  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.public_subnet_tags, {
    Name = "Public Subnet ${each.value.az}-${each.key}"
  })
}

##############################
##      Private Subnet      ##
##############################
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  for_each = { for idx, cidr in var.private_cidr_blocks : idx => {
    cidr = cidr,
    az   = var.azs[idx % length(var.azs)]
  } }

  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.private_subnet_tags, {
    Name = "Private Subnet ${each.value.az}-${each.key}"
  })
}

##############################
##     Internet Gateway     ##
##############################
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = var.igw_tags
}

##############################
##   Private Route table    ##
##############################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

##############################
##    Public Route table    ##
##############################
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
}

##############################
##       Elastic IP         ##
##############################
resource "aws_eip" "lb" {
  domain = "vpc"

  depends_on = [aws_internet_gateway.main]
}

##############################
##      NAT Gateway         ##
##############################
resource "aws_nat_gateway" "main" {
  subnet_id     = aws_subnet.public["0"].id
  allocation_id = aws_eip.lb.id
}

##############################
##    Route Association     ##
##############################
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

##############################
##    Route Association     ##
##############################
resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}
