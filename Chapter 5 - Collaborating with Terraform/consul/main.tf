# terraform {
#   backend "s3" {
#     bucket = "handbookbackend-remote-state-development"
#     key    = "terraform.tfstate"
#     region = "eu-west-2"
#   }
# }

terraform {
  backend "consul" {
    path         = "state/consul"
    address= "ec2-54-221-122-241.compute-1.amazonaws.com:8500"
    datacenter = "consul"
  }
}

provider "aws" {
  region     = var.region
  default_tags {   
    tags = {     
      Environment = "development"     
      Owner       = "Dwayne.Sutherland"     
      Project     = "terraformHandbook"   
    } 
  }
}
module "vpc" {
  source        = "github.com/turnbullpress/tf_vpc_basic.git?ref=v0.0.1"
  name          = "consul"
  cidr          = var.vpc_cidr
  public_subnet = var.public_subnet
}

resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file("~/.ssh/${var.key_name}.pub")
}

module "consul" {
  source            = "./modules/consul"
  environment       = var.environment
  token             = var.token
  encryption_key    = var.encryption_key
  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.vpc.public_subnet_id
  region            = var.region
  key_name          = var.key_name
  private_key_path = var.private_key_path
  depends_on = [aws_key_pair.key]
  tags = {     
    Environment = "development"     
    Owner       = "Dwayne.Sutherland"     
    Project     = "terraformHandbook"   
  } 
}