output "vpc-ip" {
  value = aws_vpc.my_vpc.id
  
}

output "ec-ip" {
  value = module.web-server.instance.public_ip
  
}