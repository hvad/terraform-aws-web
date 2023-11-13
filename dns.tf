#resource "aws_route53_zone" "stackthecat" {
#  name = "stackthecode.net"
#
#}
#
#resource "aws_route53_record" "nameservers" {
#  allow_overwrite = true
#  name            = "stackthecode.net"
#  ttl             = 3600
#  type            = "NS"
#  zone_id         = aws_route53_zone.stackthecat.zone_id
#
#  records = aws_route53_zone.stackthecat.name_servers
#}
#
#resource "aws_route53_record" "main" {
#  zone_id = aws_route53_zone.stackthecat.zone_id
#  name    = "stackthecode.net"
#  type    = "A"
#  ttl     = 300
#  records = [aws_instance.my_aws.public_ip]
#}
#
#resource "aws_route53_record" "www" {
#  zone_id = aws_route53_zone.stackthecat.zone_id
#  name    = "www.stackthecode.net"
#  type    = "A"
#  ttl     = 300
#  records = [aws_instance.my_aws.public_ip]
#}
