terraform {
  backend "s3" {
    bucket = "handbookbackend-remote-state-development"
    key    = "terraform.tfstate"
    region = "eu-west-2"
  }
}
data terraform_remote_state "consul" {
  backend = "consul"
  config = {
    path         = "state/consul"
    address= "ec2-54-83-174-200.compute-1.amazonaws.com:8500"
    datacenter = "consul"
  }
}

provider "consul" {
  address    = "${data.terraform_remote_state.consul.outputs.
  consul_server_address[0]}:8500"
  datacenter = "consul"
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "azs" {}

module "vpc_basic" {
  source               = "github.com/Delta-a-Sierra/vpc_basic"
  name                 = "web"
  cidr                 = "10.0.0.0/16"
  public_subnet        = ["10.0.1.0/24", "10.0.2.0/24"]
  enable_dns_hostnames = false
  subnet_az            = data.aws_availability_zones.azs.names[*]
}


