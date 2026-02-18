output "vpc_id" {
  description = "VPC ID"
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Subnet IDs"
  value = module.vpc.public_subnet_ids
}

output "ec2_ips" {
  description = "EC2 IP Addresses"
  value = module.vpc.ec2_ips
}

output "clb_dns" {
  description = "Classic LB DNS"
  value = module.vpc.clb_dns
}