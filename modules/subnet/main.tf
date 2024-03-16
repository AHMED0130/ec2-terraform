resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_ciderblock
  
  tags = {
    Name = "${var.environment_prefix}-vpc"
  }
}




resource "aws_subnet" "subnet-1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.subnet-ciderblock
  availability_zone       = var.subnet_AZ
 
  tags = {
    Name = "${var.environment_prefix}-subnet"
  }
}




resource "aws_internet_gateway" "internet-gatway" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.environment_prefix}-ig"
  }
}

resource "aws_default_route_table" "route-table" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id
  route  {
    cidr_block ="0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gatway.id
  }
  tags = {
    Name = "${var.environment_prefix}-route-table"
  }
}