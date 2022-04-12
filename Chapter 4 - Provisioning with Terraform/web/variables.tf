
variable "region" {
  type        = string
  description = "The AWS region."
}
variable "key_name" {
  type        = string
  description = "The AWS key pair to use for resources."
}
variable "key_path" {
  type        = string
  description = "Path to ssh key"
  default     = "~/.ssh"
}
variable "ami" {
  type        = map(string)
  description = "A map of AMIs."
  default     = {}
}
variable "instance_type" {
  type        = string
  description = "The instance type."
  default     = "t2.micro"
}
variable "instance_ips" {
  description = "The IPs to use for our instances"
  default     = ["10.0.1.20", "10.0.2.20"]
}
variable "owner_tag" {
  default = ["team1", "team2"]
}