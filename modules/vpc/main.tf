locals {
}

######################
# DATA
######################

data "aws_region" "now" {}

###########################################################################
# VPC
###########################################################################
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name_prefix}-${var.env}"
  }
}

###########################################################################
# Subnet
###########################################################################

# Public Subnet
resource "aws_subnet" "public" {
  for_each = { for i in var.public_subnets : i.az => i }

  availability_zone       = each.value["az"]
  cidr_block              = each.value["cidr"]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_prefix}-${each.value["name"]}-${substr(each.value["az"], -2, 0)}-${var.env}"
  }
}
# Application Subnet
resource "aws_subnet" "private_app" {
  for_each = { for i in var.private_subnets : i.az => i }

  availability_zone       = each.value["az"]
  cidr_block              = each.value["cidr"]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.name_prefix}-${each.value["name"]}-${substr(each.value["az"], -2, 0)}-${var.env}"
  }
}
# Database Subnet
resource "aws_subnet" "private_db" {
  for_each = { for i in var.database_subnets : i.az => i }

  availability_zone       = each.value["az"]
  cidr_block              = each.value["cidr"]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.name_prefix}-${each.value["name"]}-${substr(each.value["az"], -2, 0)}-${var.env}"
  }
}

###########################################################################
# Internet Gateway
###########################################################################
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name_prefix}-${var.env}"
  }
}

###########################################################################
# NAT Gateway
###########################################################################
resource "aws_eip" "nat_gateway" {
  for_each = { for i in var.public_subnets : i.az => i }

  vpc        = true
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "${var.name_prefix}-nat-gateway-${var.env}"
  }
}
resource "aws_nat_gateway" "main" {
  for_each = { for i in var.public_subnets : i.az => i }

  allocation_id = aws_eip.nat_gateway["${each.value["az"]}"].id
  subnet_id     = aws_subnet.public["${each.value["az"]}"].id
  depends_on    = [aws_internet_gateway.main]

  tags = {
    Name = "${var.name_prefix}-${var.env}"
  }
}

###########################################################################
# Route Table
###########################################################################
resource "aws_route_table" "public" {
  for_each = { for i in var.public_subnets : i.az => i }

  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name_prefix}-public-${substr(each.value["az"], -2, 0)}-${var.env}"
  }
}
resource "aws_route_table_association" "public" {
  for_each = { for i in var.public_subnets : i.az => i }

  route_table_id = aws_route_table.public["${each.value["az"]}"].id
  subnet_id      = aws_subnet.public["${each.value["az"]}"].id
}
resource "aws_route" "public" {
  for_each = { for i in var.public_subnets : i.az => i }

  route_table_id         = aws_route_table.public["${each.value["az"]}"].id
  gateway_id             = aws_internet_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table" "private" {
  for_each = { for i in var.private_subnets : i.az => i }

  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name_prefix}-private-${substr(each.value["az"], -2, 0)}-${var.env}"
  }
}
resource "aws_route_table_association" "private" {
  for_each = { for i in var.private_subnets : i.az => i }

  route_table_id = aws_route_table.private["${each.value["az"]}"].id
  subnet_id      = aws_subnet.private_app["${each.value["az"]}"].id
}
resource "aws_route" "private" {
  for_each = { for i in var.private_subnets : i.az => i }

  route_table_id         = aws_route_table.private["${each.value["az"]}"].id
  nat_gateway_id         = aws_nat_gateway.main["${each.value["az"]}"].id
  destination_cidr_block = "0.0.0.0/0"
}

######################
# Network ACL
######################

resource "aws_network_acl" "main" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = concat([for i in aws_subnet.public : i.id], [for i in aws_subnet.private_app : i.id], [for i in aws_subnet.private_db : i.id])

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = {
    Name = "${var.name_prefix}-${var.env}"
  }
}

######################
# VPC Endpoint
######################

# S3 Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.now.name}.s3"
  vpc_endpoint_type = "Gateway"
  policy            = <<POLICY
    {
        "Version": "2008-10-17",
        "Statement": [
            {
                "Action": "*",
                "Effect": "Allow",
                "Resource": "*",
                "Principal": "*"
            }
        ]
    }
    POLICY
  tags = {
    Name = "${var.name_prefix}-s3-${var.env}"
  }
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  for_each = { for i in var.private_subnets : i.az => i }

  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = aws_route_table.private["${each.value["az"]}"].id
}

# SQS Endpoint
resource "aws_vpc_endpoint" "sqs" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.now.name}.sqs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.vpc_endpoint.id,
  ]

  subnet_ids          = [for i in aws_subnet.private_app : i.id]
  private_dns_enabled = true

  tags = {
    Name = "${var.name_prefix}-sqs-${var.env}"
  }
}

# EventBridge Endpoint
resource "aws_vpc_endpoint" "event" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.now.name}.events"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.vpc_endpoint.id,
  ]

  subnet_ids          = [for i in aws_subnet.private_app : i.id]
  private_dns_enabled = true

  tags = {
    Name = "${var.name_prefix}-events-${var.env}"
  }
}

######################
# Security Group
######################

# VPC EndpointからのTraffic許可したSecurity Group
resource "aws_security_group" "allow_from_vpc_endpoint" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = ["${aws_security_group.vpc_endpoint.id}"]
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = [aws_vpc_endpoint.s3.prefix_list_id]
  }
}

# VPC Endpoint用のSecurity Group
resource "aws_security_group" "vpc_endpoint" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # tfsec:ignore:aws-vpc-no-public-egress-sgr
    cidr_blocks = ["0.0.0.0/0"] # ignored
  }
}

resource "aws_security_group_rule" "vpc_endpoint" {
  type                     = "ingress"
  from_port                = 443
  protocol                 = "tcp"
  to_port                  = 443
  source_security_group_id = aws_security_group.allow_from_vpc_endpoint.id
  security_group_id        = aws_security_group.vpc_endpoint.id
}