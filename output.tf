output "public_ip" {
  value       = aws_instance.my_aws.public_ip
  description = "The public IP of the Instance"
}
