
resource "aws_internet_gateway" "aws-igw" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = {
    Name        = "${var.app_name}-igw"
    Environment = var.env_name
  }

}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.aws-vpc.id
  count             = length(var.private_subnets)
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "${var.app_name}-private-subnet-${count.index + 1}"
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
    Name        = "${var.app_name}-public-subnet-${count.index + 1}"
    Environment = var.env_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.aws-vpc.id

  tags = {
    Name        = "${var.app_name}-routing-table-public"
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

resource "aws_vpc_endpoint" "ec2" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.aws-vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ec2"
  vpc_endpoint_type = "Interface"
  subnet_ids = [element(aws_subnet.private.*.id, count.index)]

  security_group_ids = [
    aws_security_group.service_security_group.id,
    aws_security_group.load_balancer_security_group.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.aws-vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids = [element(aws_subnet.private.*.id, count.index)]

  security_group_ids = [
    aws_security_group.service_security_group.id,
    aws_security_group.load_balancer_security_group.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_api" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.aws-vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids = [element(aws_subnet.private.*.id, count.index)]

  security_group_ids = [
    aws_security_group.service_security_group.id,
    aws_security_group.load_balancer_security_group.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "logs" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.aws-vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids = [element(aws_subnet.private.*.id, count.index)]

  security_group_ids = [
    aws_security_group.service_security_group.id,
    aws_security_group.load_balancer_security_group.id
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssm" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.aws-vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids = [element(aws_subnet.private.*.id, count.index)]

  security_group_ids = [
    aws_security_group.service_security_group.id,
    aws_security_group.load_balancer_security_group.id
  ]

  private_dns_enabled = true
}

data "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.aws-vpc.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  vpc_endpoint_id = data.aws_vpc_endpoint.s3.id
  route_table_id  = aws_route_table.public.id
}
