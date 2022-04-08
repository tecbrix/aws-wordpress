output "ec2_pub_ip" {
  description = "Public Ip of ec2"
  value       = module.ec2.ec2_pub_ip
}