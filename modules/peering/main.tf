###########################################################################
# VPC Peering
###########################################################################
resource "aws_vpc_peering_connection" "main" {
  vpc_id      = var.accepter_vpc_id
  peer_vpc_id = var.requester_vpc_id
  auto_accept = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  tags = {
    Name = "${var.name_prefix}-${var.env}"
  }
}

###########################################################################
# Route Table
###########################################################################
resource "aws_route_table" "accepter_main" {
  vpc_id = var.accepter_vpc_id
  route {
    cidr_block                = var.requester_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }
  tags = {
    Name = "${var.name_prefix}-route-to-peer-vpc-${var.env}"
  }
}
resource "aws_route_table" "requester_main" {
  vpc_id = var.requester_vpc_id
  route {
    cidr_block                = var.accepter_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }
  tags = {
    Name = "${var.name_prefix}-route-from-peer-vpc-${var.env}"
  }
}
resource "aws_main_route_table_association" "accepter" {
  vpc_id         = var.accepter_vpc_id
  route_table_id = aws_route_table.accepter_main.id
}
resource "aws_main_route_table_association" "requester" {
  vpc_id         = var.requester_vpc_id
  route_table_id = aws_route_table.requester_main.id
}
resource "aws_route" "accepter" {
  count                     = length(var.accepter_subnet_cidrs)
  route_table_id            = var.accepter_route_table_ids[count.index]
  destination_cidr_block    = var.requester_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}
resource "aws_route" "requester" {
  count                     = length(var.requester_subnet_cidrs)
  route_table_id            = var.requester_route_table_ids[count.index]
  destination_cidr_block    = var.accepter_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}
