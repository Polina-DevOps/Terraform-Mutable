# Requester's side of the connection.
resource "aws_vpc_peering_connection" "to-default-vpc" {
  peer_vpc_id                   = aws_vpc.main.id
  vpc_id                        = var.DEFAULT_VPC_ID
  auto_accept                   = true
  tags                          = {
    Name                        = "${var.ENV}-vpc-peer-to-default"
  }
}

resource "aws_route" "public-peer" {
  route_table_id              = data.aws_route_table.default.route_table_id
  destination_cidr_block      = var.VPC_PUBLICIP_CIDR
  vpc_peering_connection_id   = aws_vpc_peering_connection.to-default-vpc.id
}

resource "aws_route" "private-peer" {
  route_table_id              = data.aws_route_table.default.route_table_id
  destination_cidr_block      = var.VPC_PRIVATEIP_CIDR
  vpc_peering_connection_id   = aws_vpc_peering_connection.to-default-vpc.id
}
