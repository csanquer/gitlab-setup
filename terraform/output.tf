output "vpc" {
  value = "${module.global.vpc_id}"
}

output "dns_zone_id" {
  value = {
    id = "${module.global.dns_zone_id}"
    name = "${module.global.dns_zone_name}"
  }
}

output "bastion1" {
  value = {
    ip = "${module.global.bastion1_ip}"
    host = "${module.global.bastion1_address}"
  }
}

output "gitlab_hostname" {
  value = "${module.gitlab.gitlab_hostname}"
}
