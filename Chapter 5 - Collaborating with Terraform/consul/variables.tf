variable "region" {
  default     = "us-east-1"
  description = "The AWS region."
}
variable "prefix" {
  description = "The name of our org, i.e. examplecom."
  default     = "examplecom"
}
variable "environment" {
  description = "The name of our environment, i.e. development."
}
variable "private_key_path" {
  default = "~/.ssh/terraformHandbook"
  description = "The path to the AWS key pair to use for resources."
}
variable "key_name" {
  default = "terraformHandbook"
  description = "The AWS key pair to use for resources."
}
variable "vpc_cidr" {
  description = "The CIDR of the VPC."
}
variable "public_subnet" {
  description = "The public subnet to populate."
}
variable "token" {
  description = "Consul server token"
}
variable "encryption_key" {
  description = "Consul encryption key"
}