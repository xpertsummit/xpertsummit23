#------------------------------------------------------------------------------------------------------------
# Create VPC SEC and Subnets
#------------------------------------------------------------------------------------------------------------
# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Owner   = var.tags["Owner"]
    Name    = "${local.prefix}-vpc"
    Project = var.tags["Project"]
  }
}
# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Owner   = var.tags["Owner"]
    Name    = "${local.prefix}-igw"
    Project = var.tags["Project"]
  }
}
# Subnets
resource "aws_subnet" "subnets" {
  for_each          = local.subnet_cidrs
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.subnet_cidrs[each.key]
  availability_zone = var.region[var.region_az]

  tags = {
    Owner   = var.tags["Owner"]
    Name    = "${local.prefix}-subnet-${each.key}"
    Project = var.tags["Project"]
  }
}