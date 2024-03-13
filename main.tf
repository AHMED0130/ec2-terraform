provider "aws" {
  region = "eu-north-1"
}

variable "vpc_ciderblock" {}
variable "subnet-ciderblock" {}
variable "environment_prefix" {}
variable "subnet_AZ" {}
variable "instance_type" {}
variable "public_key" {}


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

resource "aws_default_security_group" "nginx-security-group" {
  vpc_id = aws_vpc.my_vpc.id
  
  ingress {
    from_port=22
    to_port=22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  ingress {
    from_port=8080
    to_port=8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  egress {
    from_port=0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.environment_prefix}-security-group"
  }
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

resource "aws_key_pair" "ssh-key" {
   key_name = "server-key"
   public_key = var.public_key

}



resource "aws_instance" "server" {
  ami                          = data.aws_ami.this.id
  associate_public_ip_address  = true
  instance_type                = var.instance_type

  vpc_security_group_ids       = [aws_default_security_group.nginx-security-group.id]
  subnet_id                    = aws_subnet.subnet-1.id
  availability_zone             = var.subnet_AZ
  key_name                     = aws_key_pair.ssh-key.key_name
  user_data = file("script.sh")

              
}



output "ec2-public-ip" {
  value = aws_instance.server.public_ip
  
}