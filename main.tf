terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.own_ssh_key
}

resource "aws_instance" "my_aws" {
  ami                    = var.aws_instance_ami
  instance_type          = var.aws_instance_type
  key_name               = aws_key_pair.deployer.id
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
  #!/bin/bash
  sudo dnf update -y
  sudo dnf install firewalld -y
  sudo systemctl enable firewalld
  sudo systemctl start firewalld
  sudo firewall-cmd --permanent --zone=public --add-service=http
  sudo firewall-cmd --permanent --zone=public --add-service=https
  sudo firewall-cmd --reload
  sudo dnf install httpd mod_ssl -y
  sudo cp -Rf /tmp/my_website.conf /etc/httpd/conf.d/${var.aws_web_site_name}.conf
  sudo systemctl enable httpd
  sudo systemctl start httpd
  EOF

  provisioner "file" {
    source      = "http.conf"
    destination = "/tmp/my_website.conf"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = file("/Users/davidhannequin/.ssh/ssh-terraform")
      timeout     = "2m"
    }
  }
}

resource "aws_security_group" "instance" {

  name = var.security_group_name

  ingress {
    description = "SSH from the internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "80 from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "80 from the internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

}
