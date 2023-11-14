data "aws_route53_zone" "my_zone" {
  name = "${var.aws_web_site_name}."
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.my_zone.zone_id
  name    = "www.${var.aws_web_site_name}"
  type    = "A"
  ttl     = 300 # 86400 is normal value and 300 for prepare a change
  records = [aws_eip.my_aws_eip.public_ip]
}

resource "aws_route53_record" "root" {
  zone_id = data.aws_route53_zone.my_zone.zone_id
  name    = var.aws_web_site_name
  type    = "A"
  ttl     = 300 # 86400 is normal value and 300 for prepare a change
  records = [aws_eip.my_aws_eip.public_ip]
}
