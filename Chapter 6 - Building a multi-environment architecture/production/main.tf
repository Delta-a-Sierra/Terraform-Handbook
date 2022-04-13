terraform {
  backend "s3" {
    region = "eu-west-2"
    bucket = "handbookbackend-remote-state-development"
    key    = "terraform.dev.tfstate"
  }
}


provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = "dev"
      Owner       = "Dwayne.Sutherland"
      Project     = "terraformHandbook"
    }
  }
}



resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file("~/.ssh/${var.key_name}.pub")
}

module "vpc" {
  source          = "./modules/vpc"
  region          = var.region
  environment     = var.environment
  key_name        = var.key_name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  bastion_ami     = var.bastion_ami
  owner           = var.owner

  depends_on = [
    aws_key_pair.key
  ]
}

