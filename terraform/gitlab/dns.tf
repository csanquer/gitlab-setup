resource "aws_route53_record" "gitlab" {
  zone_id = "${var.dns_zone_id}"
  name    = "${var.gitlab_dns_subdomain}.${var.dns_zone_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.gitlab.dns_name}"
    zone_id                = "${aws_elb.gitlab.zone_id}"
    evaluate_target_health = true
  }
}
