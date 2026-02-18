output "vpc_id" {
  description = "VPC ID"
  value = aws_vpc.my_vpc.id
}

output "public_subnet_ids" {
  description = "Subnet IDs"
  value = aws_subnet.public_subnet[*].id
}

output "ec2_ips" {
  description = "EC2 IP Addresses"
  value = aws_instance.web[*].public_ip
}

output "clb_dns" {
  description = "Application LB DNS"
  value = aws_elb.app_elb.dns_name
}