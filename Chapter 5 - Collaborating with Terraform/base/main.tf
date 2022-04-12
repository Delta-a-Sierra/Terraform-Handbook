# terraform {
#   backend "s3" {
#     bucket = "handbookbackend-remote-state-development"
#     key    = "terraform.tfstate"
#     region = "eu-west-2"
#   }
# }

provider "aws" {
  region = var.region
}

data terraform_remote_state "web_backend" {
  backend = "s3"
  config = {
    bucket = "handbookbackend-remote-state-development"
    key    = "terraform.tfstate"
    region = "eu-west-2"
  }
}

resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file("~/.ssh/${var.key_name}.pub")
}

resource "aws_instance" "web" {
  ami           = var.ami[var.region]
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = data.terraform_remote_state.web_backend.outputs.public_subnet_ids[count.index]
  # private_ip                  = var.instance_ips[count.index]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web_host_sg.id]
  count                       = length(var.instance_ips)
  tags = {
    Name  = "nginx-srv-${format("%03d", count.index)}"
    Owner = "Dwayne.Sutherland"
  }

  volume_tags = {
    Name  = "nginx-srv-${format("%03d", count.index)}"
    Owner = "Dwayne.Sutherland"
  }

  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${var.key_path}/${var.key_name}")
  }

  provisioner "remote-exec" {
    script = "files/bootstrap_puppet.sh"
  }
  provisioner "file" {
    content     = templatefile("files/index.html.tpl", { hostname = "web-${format("%03d", count.index + 1)}" })
    destination = "/tmp/index.html"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/index.html /var/www/html/index.html"
    ]
  }

}

resource "aws_elb" "web" {
  name            = "web-elb"
  subnets         = data.terraform_remote_state.web_backend.outputs.public_subnet_ids.*
  security_groups = [aws_security_group.web_inbound_sg.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  instances                   = aws_instance.web.*.id
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}
