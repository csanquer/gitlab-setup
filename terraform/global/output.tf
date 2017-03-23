output "vpc_id" {
  value = "${aws_vpc.gitlab.id}"
}

output "dns_zone_id" {
  value = "${data.aws_route53_zone.selected.zone_id}"
}

output "dns_zone_name" {
  value = "${data.aws_route53_zone.selected.name}"
}

output "admin_ssh_key" {
  value = "${aws_key_pair.admin.key_name}"
}

output "sg_bastions_id" {
  value = "${aws_security_group.bastions.id}"
}

output "private_subnet_ids" {
  value = {
    private1 = "${aws_subnet.private1.id}"
    private2 = "${aws_subnet.private2.id}"
  }
}

output "public_subnet_ids" {
  value = {
    public1 = "${aws_subnet.public1.id}"
    public2 = "${aws_subnet.public2.id}"
  }
}

output "ubuntu_xenial_ami" {
  value = "${data.aws_ami.ubuntu_xenial.id}"
}

output "bastion1_ip" {
  value = "${aws_instance.bastion1.public_ip}"
}

output "bastion1_address" {
  value = "${aws_route53_record.bastion1.fqdn}"
}
