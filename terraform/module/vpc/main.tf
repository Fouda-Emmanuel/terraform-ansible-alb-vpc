provider "aws" {
  region = var.region
}

resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = var.vpc_tag_name
  }
}

resource "aws_subnet" "public_subnet" {
  count = length(var.subnet_cidr_block)
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.subnet_cidr_block[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_rt_association" {
  count = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Classic load balancer SG"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_ipv6" {
  security_group_id = aws_security_group.alb_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv6         = "::/0"
}

resource "aws_vpc_security_group_egress_rule" "alb_all_traffic_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

resource "aws_vpc_security_group_egress_rule" "alb_all_traffic_ipv6" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" 
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "EC2 instance SG"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "ec2-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_from_alb" {
  security_group_id = aws_security_group.ec2_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  referenced_security_group_id = aws_security_group.alb_sg.id
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.ec2_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "154.72.161.117/32" 
}

resource "aws_vpc_security_group_egress_rule" "ec2_all_traffic_ipv4" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "ec2_all_traffic_ipv6" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}


resource "aws_key_pair" "my_keypair" {
  key_name   = "my-key-pair"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_instance" "web" {
  count = length(aws_subnet.public_subnet)
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = aws_key_pair.my_keypair.key_name
  subnet_id = aws_subnet.public_subnet[count.index].id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  associate_public_ip_address = true
  
  tags = {
    Name = var.instance_names[count.index]
    Project = "learning-proj"
    Environment = "dev"
  }
} 

# Classic load balancer
resource "aws_elb" "app_elb" {
  name               = "my-app-clb"
  subnets = aws_subnet.public_subnet[*].id
  security_groups = [aws_security_group.alb_sg.id]
  internal = false

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 60
  connection_draining         = true
  connection_draining_timeout = 300

  tags = {
    Name = "my-app-clb"
    Environment = "dev"
  }
}

resource "aws_elb_attachment" "web_attach" {
  count = length(aws_instance.web)
  elb      = aws_elb.app_elb.id
  instance = aws_instance.web[count.index].id
}