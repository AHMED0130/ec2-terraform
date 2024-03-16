provider "aws" {
  region = "eu-north-1"
}





module "app-subnet" {
  source = "./modules/subnet"
  subnet-ciderblock = var.subnet-ciderblock
  environment_prefix= var.environment_prefix
  subnet_AZ = var.subnet_AZ
  vpc_ciderblock = var.subnet-ciderblock  
}

module "web-server" {
  source = "./modules/web-server"
  environment_prefix = var.environment_prefix
  subnet_AZ = var.subnet_AZ
  instance_type = var.instance_type
  public_key = var.public_key
  vpc_id = module.app-subnet.my_vpc.id
  subnet_id = module.app-subnet.subnet.id
}
 