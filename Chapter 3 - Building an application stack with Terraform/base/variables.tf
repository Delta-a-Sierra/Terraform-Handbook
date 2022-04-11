variable "region" {
  type        = string
  description = "The AWS region."
  default     = "us-east-1"
}

variable "ami" {
  type = map(string)
  default = {
    us-east-1 = "ami-0d729a60"
    us-west-1 = "ami-7c4b331c"
  }
  description = "The AMIs to use."
}

variable "instance_type" {
  type        = string
  description = "ec2 instance type"
  default     = "t2.micro"
}
variable "region_list" {
  description = "AWS availability zones."
  default     = ["us-east-1a", "us-east-1b"]
}