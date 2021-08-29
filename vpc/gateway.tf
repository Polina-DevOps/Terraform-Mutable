resource "aws_internet_gateway" "igw" {
  vpc_id            = aws_vpc.main.id

  tags              = {
    Name            = "${var.ENV}-custom-igw"
  }
}

resource "aws_eip" "cutom_eip" {
  vpc      = true
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.cutom_eip.id
  subnet_id     = aws_subnet.public.*.id[0]

  tags = {
    Name = "${var.ENV}-custom-NATGW"
  }
  depends_on = [aws_internet_gateway.igw]
}