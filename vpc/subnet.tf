resource "aws_subnet" "private" {
  count                 = length(var.VPC_PRVATEIP_CIDR)
  vpc_id                = aws_vpc.main.id
  cidr_block            = element(var.VPC_PRVATEIP_CIDR,count.index )

  tags                  = {
    Name                = "${var.ENV}-PRIVATE-${count.index+1}"
  }
}

resource "aws_subnet" "public" {
  count                 = length(var.VPC_PUBLICIP_CIDR)
  vpc_id                = aws_vpc.main.id
  cidr_block            = element(var.VPC_PUBLICIP_CIDR,count.index )

  tags                  = {
    Name                = "${var.ENV}-PUBLIC-${count.index+1}"
  }
}
