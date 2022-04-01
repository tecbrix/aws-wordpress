output "ec2_pub_ip" {
  description = "Public Ip of ec2"
  value       = module.ec2.ec2_pub_ip
}

output "ec2_pub_dns" {
  description = "Public DNS of ec2"
  value       = module.ec2.ec2_pub_dns_name
}

output "wordpress_url" {
  description = "wordpress url is"
  value       = "Wordpress url is http://${module.ec2.ec2_pub_dns_name}"
}
# output "ec2_pub_prvt_name" {
#   description = "Private DNS of ec2"
#   value       = module.ec2.private_dns 
# }