resource "aws_vpc" "aws-vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = {
    Name        = "${var.app_name}-vpc"
    Environment = var.env_name
  }
}

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.aws-vpc.id
}

resource "aws_network_acl_rule" "accept" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "deny" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = -1
  egress         = false
  protocol       = "-1"
  rule_action    = "deny"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "tcp_dns" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 1
  egress         = true
  protocol       = "TCP"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "udp_dns" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 2
  egress         = true
  protocol       = "UDP"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "tcp_https" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 3
  egress         = true
  protocol       = "TCP"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "allow_all" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "deny_all" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = -1
  egress         = true
  protocol       = "-1"
  rule_action    = "deny"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}


