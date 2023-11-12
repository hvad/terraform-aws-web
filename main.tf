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
  sudo dnf install dnf-automatic -y
  sudo sed -i 's/upgrade_type = default/upgrade_type = security/g' /etc/dnf/automatic.conf 
  sudo sed -i 's/apply_updates = no/apply_updates = yes/g' /etc/dnf/automatic.conf 
  systemctl enable --now dnf-automatic.timer
  sudo dnf install httpd mod_ssl -y
  sudo cp -Rf /tmp/http.conf /etc/httpd/conf.d/${var.aws_web_site_name}.conf
  sudo mkdir /var/www/html/stackthecode.net
  sudo chown -Rf apache:apache /var/www/html/stackthecode.net
  sudo echo "<html><body><h1>It works!</h1></body></html>" > /var/www/html/stackthecode.net/index.html
  sudo systemctl enable httpd
  sudo systemctl start httpd
  EOF

  provisioner "file" {
    source      = "http.conf"
    destination = "/tmp/http.conf"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = file(var.own_path_ssh_private_key)
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
