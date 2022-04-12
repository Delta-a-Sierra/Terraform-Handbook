output "public_subnet_ids" {
  value = module.vpc_basic.public_subnet_ids.*
}

output "vpc_id" {
  value = module.vpc_basic.vpc_id
}

output "vpc_cidr" {
  value = module.vpc_basic.cidr
}