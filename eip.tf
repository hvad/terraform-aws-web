resource "aws_eip" "my_aws_eip" {
  instance = aws_instance.my_aws.id
  domain   = "vpc"
}

resource "aws_eip_association" "my_aws_eip_assoc" {
  instance_id   = aws_instance.my_aws.id
  allocation_id = aws_eip.my_aws_eip.id
}
