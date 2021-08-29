resource "aws_subnet" "private" {
  count                 = length(var.PRIVATE_SUBNET_CIDR)
  vpc_id                = aws_vpc.main.id
  cidr_block            = element(var.PRIVATE_SUBNET_CIDR,count.index )

  tags                  = {
    Name                = "${var.ENV}-PRIVATE-${count.index+1}"
  }
}

resource "aws_subnet" "public" {
  depends_on            = [aws_vpc_ipv4_cidr_block_association.public_cidr]
  count                 = length(var.PUBLIC_SUBNET_CIDR)
  vpc_id                = aws_vpc.main.id
  cidr_block            = element(var.PUBLIC_SUBNET_CIDR,count.index )

  tags                  = {
    Name                = "${var.ENV}-PUBLIC-${count.index+1}"
  }
}

resource "aws_route_table_association" "public_rt" {
  depends_on            = [aws_nat_gateway.natgw]
  count                 = length(var.PUBLIC_SUBNET_CIDR)
  subnet_id             = element(aws_route_table.public.*.id,count.index )
  route_table_id        = aws_route_table.public.id
}

resource "aws_route_table_association" "private_rt" {
  depends_on            = [aws_nat_gateway.natgw]
  count                 = length(var.PRIVATE_SUBNET_CIDR)
  subnet_id             = element(aws_route_table.private.*.id,count.index )
  route_table_id        = aws_route_table.private.id
}
