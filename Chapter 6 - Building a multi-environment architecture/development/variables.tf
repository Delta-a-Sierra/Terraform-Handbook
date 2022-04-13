variable "region" {
  type        = string
  description = "The AWS region."
}
variable "prefix" {
  type        = string
  description = "The name of our org, e.g., examplecom."
}
variable "environment" {
  type        = string
  description = "The name of our environment, e.g., development."
}
variable "key_name" {
  type        = string
  description = "The AWS key pair to use for resources."
}
variable "vpc_cidr" {
  type        = string
  description = "The CIDR of the VPC."
}
variable "public_subnets" {
  type        = list(string)
  default     = []
  description = "The list of public subnets to populate."
}
variable "private_subnets" {
  type        = list(string)
  default     = []
  description = "The list of private subnets to populate."
}
variable "bastion_ami" {
  default     = {}
  description = "ami to be used for the bastion host"
}

variable "ec2_key"{
  default = "terraformHandbook"
}

variable "owner" {}