
resource "aws_internet_gateway" "aws-igw" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = {
    Name        = "${var.app_name}-${var.env_name}-igw"
    Environment = var.env_name
  }

}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.aws-vpc.id
  count             = length(var.private_subnets)
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "${var.app_name}-${var.env_name}-private-subnet-${count.index + 1}"
    Environment = var.env_name
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.app_name}-${var.env_name}-public-subnet-${count.index + 1}"
    Environment = var.env_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.aws-vpc.id

  tags = {
    Name        = "${var.app_name}-${var.env_name}-routing-table-public"
    Environment = var.env_name
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws-igw.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}


resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = aws_vpc.aws-vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids = [for o in aws_subnet.private : o.id]

  security_group_ids = [
    aws_security_group.service_security_group.id,
    aws_security_group.load_balancer_security_group.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = aws_vpc.aws-vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids = [for o in aws_subnet.private : o.id]

  security_group_ids = [
    aws_security_group.service_security_group.id,
    aws_security_group.load_balancer_security_group.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id            = aws_vpc.aws-vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids = [for o in aws_subnet.private : o.id]

  security_group_ids = [
    aws_security_group.service_security_group.id,
    aws_security_group.load_balancer_security_group.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id            = aws_vpc.aws-vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_route_table.public.id,aws_vpc.aws-vpc.default_route_table_id]

}
