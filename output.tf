output "public_ip" {
  value       = aws_eip.my_aws_eip.public_ip
  description = "The public IP of the Instance"
}
