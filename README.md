# Terraform plan to deploy AWS instance and DNS

## Description 

This terraform plan deploy Linux server with Apache Httpd and virtual host, create
record for domain name in existing zone and let's encrypt SSL certificate.

## Requires

Before execute plan you have to create tfvars file with variables below :

```
- aws_region = "<AWS region to deploy Web server>"

- aws_instance_type = "<Size of instance>"

- aws_instance_ami = "<Amazone machine image Amazone Linux 2023 is a Linux RPM distribution>"

- own_ssh_key = "<Public ssh RSA key without password on private key>"

- own_path_ssh_private_key = "<Path of SSH private key without password>" 

- security_group_name =  "<Security group name>"

- aws_web_site_name = "<Web site name>" 

- aws_domain_name "<DNS zone with a dot in the end for example : example.net.>"

- own_email = "<Email of contact for let encrypt SSL certificate>"

- own_timezone = "<Time zone of AMI. On Linux Amazone 2023 it is not Paris>"
```

**Warning :** SSH private key with password are not support by terraform AWS provider.

## How to use 

To check the plan with a file vars.tfvars :

```
$ terraform plan -var-file="vars.tfvars"
```

To deploy with a file vars.tfvars :

```
$ terraform apply -var-file="vars.tfvars"
```

To destroy : 

```
$ terraform destroy
```

## How to delete any resources added by terraform

List all states :

```
$ terraform state list 
```

Remove desired resource from state :

```
$ terraform state rm <name>
```
