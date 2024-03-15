resource "aws_default_security_group" "nginx-security-group" {
  vpc_id = var.vpc_id
  
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
  subnet_id                    = var.subnet_id
  availability_zone             = var.subnet_AZ
  key_name                     = aws_key_pair.ssh-key.key_name
  user_data = file("script.sh")

              
}

