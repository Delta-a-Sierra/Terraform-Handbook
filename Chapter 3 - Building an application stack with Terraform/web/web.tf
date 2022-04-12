provider "aws" {
  region = var.region
}

module "vpc_basic" {
  source               = "github.com/turnbullpress/tf_vpc_basic.git?ref=v0.0.1"
  name                 = "web"
  cidr                 = "10.0.0.0/16"
  public_subnet        = "10.0.1.0/24"
  enable_dns_hostnames = false
}

resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file("~/.ssh/${var.key_name}.pub")
}

resource "aws_instance" "web" {
  ami                         = var.ami[var.region]
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = module.vpc_basic.public_subnet_id
  private_ip                  = var.instance_ips[count.index]
  associate_public_ip_address = true
  user_data                   = file("files/web_bootstrap.sh")
  vpc_security_group_ids      = [aws_security_group.web_host_sg.id]
  count                       = length(var.instance_ips)
  tags = {
    Name  = "web-${format("%03d", count.index)}"
    Owner = "Dwayne.Sutherland"
  }

  volume_tags = {
    Name  = "web-${format("%03d", count.index)}"
    Owner = "Dwayne.Sutherland"
  }
  
}

resource "aws_elb" "web" {
  name            = "web-elb"
  subnets         = [module.vpc_basic.public_subnet_id]
  security_groups = [aws_security_group.web_inbound_sg.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  instances = aws_instance.web.*.id
}

resource "aws_security_group" "web_inbound_sg" {
  name        = "web_inbound"
  description = "Allow HTTP from Anywhere"
  vpc_id      = module.vpc_basic.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web_host_sg" {
  name        = "web_host"
  description = "Allow SSH & HTTP to web hosts"
  vpc_id      = module.vpc_basic.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [module.vpc_basic.cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}