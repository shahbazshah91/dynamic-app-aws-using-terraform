#create vpc

resource "aws_vpc" "vpc" {
    cidr_block            = var.vpc_cidr
    instance_tenancy      = "default"
    enable_dns_hostnames  = true

    tags = {
        Name = "${var.project_name}-${var.environment}-vpc"
    }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-${var.environment}-gw"
  }
}

data "aws_availability_zones" "available_zones" {}

output "zones" {
    value = data.aws_availability_zones.available_zones.names
}

resource "aws_subnet" "public_subnet_az1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.vpc_public_subnet_az1_cidr
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available_zones.names[0]

  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet-az1"
  }
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.vpc_public_subnet_az2_cidr
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available_zones.names[1]

  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet-az2"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_az1_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_az2_association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "private_app_subnet_az1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.vpc_private_app_subnet_az1_cidr
  availability_zone = data.aws_availability_zones.available_zones.names[0]

  tags = {
    Name = "${var.project_name}-${var.environment}-private-app-subnet-az1"
  }
}

resource "aws_subnet" "private_app_subnet_az2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.vpc_private_app_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.available_zones.names[1]

  tags = {
    Name = "${var.project_name}-${var.environment}-private-app-subnet-az2"
  }
}

resource "aws_subnet" "private_data_subnet_az1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.vpc_private_data_subnet_az1_cidr
  availability_zone = data.aws_availability_zones.available_zones.names[0]

  tags = {
    Name = "${var.project_name}-${var.environment}-private-data-subnet-az1"
  }
}

resource "aws_subnet" "private_data_subnet_az2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.vpc_private_data_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.available_zones.names[1]

  tags = {
    Name = "${var.project_name}-${var.environment}-private-data-subnet-az2"
  }
}


