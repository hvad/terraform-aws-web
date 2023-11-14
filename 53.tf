resource "aws_route53_zone" "primary" {
  name ="${var.aws_web_site_name}." 
  force_destroy = false
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.${var.aws_web_site_name}"
  type    = "A"
  ttl     = 86400 # 86400 is normal value and 300 for prepare a change
  records = [aws_eip.my_aws_eip.public_ip]
}

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "${var.aws_web_site_name}"
  type    = "A"
  ttl     = 86400 # 86400 is normal value and 300 for prepare a change
  records = [aws_eip.my_aws_eip.public_ip]
}
