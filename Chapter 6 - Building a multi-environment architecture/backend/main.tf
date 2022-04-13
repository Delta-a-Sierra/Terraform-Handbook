provider "aws" {
  region = var.region
}

module "backend" {
  source      = "./modules/remote_state"
  region      = var.region
  prefix      = "handbookbackend"
  environment = "development"
}