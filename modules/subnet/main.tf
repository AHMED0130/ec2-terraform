resource "aws_subnet" "subnet-1" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet-ciderblock
  availability_zone       = var.subnet_AZ
 
  tags = {
    Name = "${var.environment_prefix}-subnet"
  }
}




resource "aws_internet_gateway" "internet-gatway" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.environment_prefix}-ig"
  }
}

resource "aws_default_route_table" "route-table" {
  default_route_table_id = var.my_vpc_default_route_table_id
  route  {
    cidr_block ="0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gatway.id
  }
  tags = {
    Name = "${var.environment_prefix}-route-table"
  }
}