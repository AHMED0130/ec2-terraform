output "vpc-ip" {
  value = module.app-subnet.my_vpc.id
  
}

output "ec-ip" {
  value = module.web-server.instance.public_ip
  
}