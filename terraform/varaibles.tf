variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_tag_name" {
  description = "VPC tag name"
  default     = "my-vpc"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "availability_zones" {
  description = "AZs for the subnets"
  type        = list(string)
  default     = ["us-east-1a","us-east-1b"]
}

variable "ami_id" {
  description = "AMI ID for EC2"
  default     = "ami-0b6c6ebed2801a5cb"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "instance_names" {
  description = "Names of EC2 instances"
  type        = list(string)
  default     = ["web01","web02"]
}
