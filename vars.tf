variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_instance_type" {
  description = "AWS instance type"
  type        = string
}

variable "aws_instance_ami" {
  description = "AMI"
  type        = string
}

variable "own_ssh_key" {
  description = "SSH Public key."
  type        = string
}

variable "own_path_ssh_private_key" {
  description = "Path to private key"
  type        = string
}

variable "security_group_name" {
  description = "The name of my security group"
  type        = string
}

variable "aws_web_site_name" {
  description = "Web site name"
  type        = string
}

variable "aws_domain_name" {
  description = "Domaine name"
  type        = string
}

variable "own_email" {
  description = "Email"
  type        = string
}

variable "own_timezone" {
  description = "Time zone"
  type        = string
}
