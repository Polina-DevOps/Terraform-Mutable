resource "aws_vpc" "main" {
  cidr_block                = var.VPC_PRIVATEIP_CIDR
  enable_dns_hostnames      = true
  enable_dns_support        = true
  tags                      = {
    Name                    = "${var.ENV}-vpc"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "public_cidr" {
  vpc_id                    = aws_vpc.main.id
  cidr_block                = var.VPC_PUBLICIP_CIDR
}
