# Security Groups
## Need to create 4 of them as our Security Groups are linked to a VPC
resource "aws_security_group" "sg-mgmt" {
  name        = "${local.prefix}-sg-mgmt"
  description = "Allow MGMT SSH, HTTPS and ICMP traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.admin_cidr}"]
  }
  ingress {
    from_port   = var.admin_port
    to_port     = var.admin_port
    protocol    = "tcp"
    cidr_blocks = ["${var.admin_cidr}"]
  }
  ingress {
    from_port   = 541
    to_port     = 541
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8 # the ICMP type number for 'Echo'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["${var.admin_cidr}"]
  }
  ingress {
    from_port   = 0 # the ICMP type number for 'Echo Reply'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["${var.admin_cidr}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Owner   = var.tags["Owner"]
    Name    = "${local.prefix}-sg-mgmt"
    Project = var.tags["Project"]
  }
}

resource "aws_security_group" "sg-private" {
  name        = "${local.prefix}-sg-private"
  description = "Allow all connections from spokes"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow all from spokes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all to spokes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Owner   = var.tags["Owner"]
    Name    = "${local.prefix}-sg-private"
    Project = var.tags["Project"]
  }
}

resource "aws_security_group" "sg-public" {
  name        = "${local.prefix}-sg-public"
  description = "Allow all tcp/upd traffic and ICMP"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8 # the ICMP type number for 'Echo'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0 # the ICMP type number for 'Echo Reply'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Owner   = var.tags["Owner"]
    Name    = "${local.prefix}-sg-public"
    Project = var.tags["Project"]
  }
}

resource "aws_security_group" "sg-allow-all" {
  name        = "${local.prefix}-sg-allow-all"
  description = "Allow ALL"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Owner   = var.tags["Owner"]
    Name    = "${local.prefix}-sg-allow-all"
    Project = var.tags["Project"]
  }
}

resource "aws_security_group" "sg-bastion" {
  name        = "${local.prefix}-sg-bastion"
  description = "Allow all tcp and udp and ICMP traffic from admin_cidr and RFC1918"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${var.admin_cidr}", "192.168.0.0/16", "10.0.0.0/8", "172.16.0.0/12"]
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["${var.admin_cidr}", "192.168.0.0/16", "10.0.0.0/8", "172.16.0.0/12"]
  }
  ingress {
    from_port   = 8 # the ICMP type number for 'Echo'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0 # the ICMP type number for 'Echo Reply'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Owner   = var.tags["Owner"]
    Name    = "${local.prefix}-sg-bastion"
    Project = var.tags["Project"]
  }
}