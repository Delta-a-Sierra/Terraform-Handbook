# terraform {
#   required_providers {
#     cloudflare = {
#       source = "cloudflare/cloudflare"
#       version = "~> 3.0"
#     }
#   }
# }

# variable "cloudflare_email" {
#   type = string
#   description = "The Cloudflare email of your account"
# }

# variable "cloudflare_token" {
#   type = string
#   description = "The Cloudflare token"
# }

# variable "domain" {
#   type = string
#   description = "The domain of our web service."
# }

variable "web_instance_count" {
  type = number
  default     = 2
  description = "The number of Web instances"
}

variable "app_instance_count" {
  type = number
  default     = 2
  description = "The number of App instances"
}

# provider "cloudflare" {
#   email = var.cloudflare_email
#   token = var.cloudflare_token
# }

resource "aws_key_pair" "ec2key" {
  key_name   = var.ec2_key
  public_key = file("~/.ssh/${var.ec2_key}.pub")
}

module "web" {
  source             = "github.com/turnbullpublishing/tf_web"
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  web_instance_count = var.web_instance_count
  app_instance_count = var.app_instance_count
  # domain             = var.domain
  region             = var.region
  key_name           = var.ec2_key
  owner = var.owner

  depends_on = [aws_key_pair.ec2key]
}

output "web_elb_address" {
  value = module.web.web_elb_address
}

output "web_host_addresses" {
  value = [module.web.web_host_addresses]
}

output "app_host_addresses" {
  value = [module.web.app_host_addresses]
}
