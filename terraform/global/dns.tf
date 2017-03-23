data "aws_route53_zone" "selected" {
  name = "${var.aws_dns_zone}"
}

resource "aws_route53_record" "bastion1" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "bastion1.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.bastion1.public_ip}"]
}
