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
  sudo sed -i 's/WEB_SITE_NAME/${var.aws_web_site_name}/g' /etc/httpd/conf.d/${var.aws_web_site_name}.conf
  sudo mkdir /var/www/html/${var.aws_web_site_name}
  sudo chown -Rf apache:apache /var/www/html/${var.aws_web_site_name}
  sudo echo "<html><body><h1>It works!</h1></body></html>" > /var/www/html/${var.aws_web_site_name}/index.html
  sudo systemctl enable httpd
  sudo systemctl start httpd
  sudo dnf install -y augeas-libs
  sudo python3 -m venv /opt/certbot/
  sudo /opt/certbot/bin/pip install --upgrade pip
  sudo /opt/certbot/bin/pip install certbot certbot-apache
  sudo ln -s /opt/certbot/bin/certbot /usr/bin/certbot
  sudo cp -Rf /tmp/letencrypt.sh /usr/local/bin/letencrypt.sh
  sudo chmod a+x /usr/local/bin/letencrypt.sh
  sudo sed -i 's/DOMAIN/${var.aws_web_site_name}/g' /usr/local/bin/letencrypt.sh
  sudo sed -i 's/EMAIL/${var.own_email}/g' /usr/local/bin/letencrypt.sh
  sudo cp -Rf /tmp/letencrypt.service /etc/systemd/system/letencrypt.service
  sudo cp -Rf /tmp/letencrypt.timer /etc/systemd/system/letencrypt.timer
  sudo systemctl start letencrypt.service
  sudo systemctl enable letencrypt.timer
  sudo timedatectl set-timezone ${var.own_timezone}
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

  provisioner "file" {
    source      = "letencrypt.sh"
    destination = "/tmp/letencrypt.sh"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = file(var.own_path_ssh_private_key)
      timeout     = "2m"
    }
  }

  provisioner "file" {
    source      = "letencrypt.service"
    destination = "/tmp/letencrypt.service"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = file(var.own_path_ssh_private_key)
      timeout     = "2m"
    }
  }

  provisioner "file" {
    source      = "letencrypt.timer"
    destination = "/tmp/letencrypt.timer"

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
