#resource "aws_route53_zone" "primary" {
#  name = "stackthecode.net"
#}
#
#resource "aws_route53_record" "main" {
#  zone_id = aws_route53_zone.primary.zone_id
#  name    = "stackthecode.net"
#  type    = "A"
#  ttl     = 300
#  records = [aws_instance.my_aws.public_ip]
#}
#
#resource "aws_route53_record" "www" {
#  zone_id = aws_route53_zone.primary.zone_id
#  name    = "www.stackthecode.net"
#  type    = "A"
#  ttl     = 300
#  records = [aws_instance.my_aws.public_ip]
#}
