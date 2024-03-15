provider "aws" {
  region = "eu-north-1"
}


resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_ciderblock
  
  tags = {
    Name = "${var.environment_prefix}-vpc"
  }
}


module "app-subnet" {
  source = "./modules/subnet"
  subnet-ciderblock = var.subnet-ciderblock
  environment_prefix= var.environment_prefix
  subnet_AZ = var.subnet_AZ
  vpc_id = aws_vpc.my_vpc.id
  my_vpc_default_route_table_id= aws_vpc.my_vpc.default_route_table_id
  
}

module "web-server" {
  source = "./modules/web-server"
  environment_prefix = var.environment_prefix
  subnet_AZ = var.subnet_AZ
  instance_type = var.instance_type
  public_key = var.public_key
  vpc_id = aws_vpc.my_vpc.id
  subnet_id = module.app-subnet.subnet.id
}
 









