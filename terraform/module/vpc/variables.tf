variable "region" {
  description = "VPC Region"
  default = "us-east-1"
}

variable "vpc_tag_name" {
  description = "VPC Tag name"
  default = "my-vpc"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "Subnet CIDR Block"
  type = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24" ]
}

variable "availability_zones" {
  description = "Availability zone"
  type = list(string)
  default = [ "us-east-1a", "us-east-1b"]
}

variable "ami_id" {
  description = "AMI ID"
  type = string
  default = "ami-0b6c6ebed2801a5cb"
}

variable "instance_type" {
  description = "Instance type"
  default = "t3.micro"
}

variable "instance_names" {
  description = "Instance Names "
  type = list(string)
  default = ["web01", "web02"]
}