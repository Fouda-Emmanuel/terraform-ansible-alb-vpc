terraform {
  backend "s3" {
    bucket = "emson-iam-s3-bucket"
    key = "terraform-ansible-alb-vpc/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "my-state-lock-record"
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./module/vpc"

  region = var.region
  vpc_tag_name = var.vpc_tag_name
  vpc_cidr_block = var.vpc_cidr_block
  subnet_cidr_block = var.subnet_cidr_block
  availability_zones = var.availability_zones
  ami_id = var.ami_id
  instance_type = var.instance_type
  instance_names = var.instance_names
}