resource "aws_subnet" "private" {
  count                 = length(var.PRIVATE_SUBNET_CIDR)
  vpc_id                = aws_vpc.main.id
  cidr_block            = element(var.PRIVATE_SUBNET_CIDR,count.index )

  tags                  = {
    Name                = "${var.ENV}-PRIVATE-${count.index+1}"
  }
}

resource "aws_subnet" "public" {
  count                 = length(var.PUBLIC_SUBNET_CIDR)
  vpc_id                = aws_vpc.main.id
  cidr_block            = element(var.PUBLIC_SUBNET_CIDR,count.index )

  tags                  = {
    Name                = "${var.ENV}-PUBLIC-${count.index+1}"
  }
}

