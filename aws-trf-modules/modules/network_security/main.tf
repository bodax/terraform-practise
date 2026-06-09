resource "aws_security_group" "ssh" {
  name   = var.ssh_sg_name
  vpc_id = var.vpc_id

  tags = {
    Name = var.ssh_sg_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.ssh.id
  for_each          = toset(var.allowed_ip_range)

  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_ipv4   = each.value
}

resource "aws_vpc_security_group_egress_rule" "ssh" {
  security_group_id = aws_security_group.ssh.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_security_group" "public_http" {
  name   = var.public_http_sg_name
  vpc_id = var.vpc_id

  tags = {
    Name = var.public_http_sg_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_http" {
  security_group_id = aws_security_group.public_http.id
  for_each          = toset(var.allowed_ip_range)

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_ipv4   = each.value
}

resource "aws_vpc_security_group_egress_rule" "public_http" {
  security_group_id = aws_security_group.public_http.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_security_group" "private_http" {
  name   = var.private_http_sg_name
  vpc_id = var.vpc_id

  tags = {
    Name = var.private_http_sg_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_http" {
  security_group_id            = aws_security_group.private_http.id
  referenced_security_group_id = aws_security_group.public_http.id

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "private_http" {
  security_group_id = aws_security_group.private_http.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}
