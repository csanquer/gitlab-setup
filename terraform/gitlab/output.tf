output "gitlab_hostname" {
  value = "${var.gitlab_dns_subdomain}.${var.aws_dns_zone}"
}

output "sg_gitlab_id" {
  value = "${aws_security_group.gitlab.id}"
}

output "gitlab_init_bucket_arn" {
  value = "${aws_s3_bucket.gitlab_init.arn}"
}

output "gitlab_init_bucket" {
  value = "${aws_s3_bucket.gitlab_init.bucket}"
}

output "gitlab_config_bucket_key" {
  value = "${aws_s3_bucket_object.gitlab_config.key}"
}

output "gitlab_bootstrap_bucket_key" {
  value = "${aws_s3_bucket_object.gitlab_bootstrap.key}"
}

output "gitlab_env_sh_bucket_key" {
  value = "${aws_s3_bucket_object.gitlab_env_sh.key}"
}

output "gitlab_env_yml_bucket_key" {
  value = "${aws_s3_bucket_object.gitlab_env_yml.key}"
}

output "gitlab_db_address" {
  value = "${aws_db_instance.gitlab.address}"
}

output "gitlab_db_port" {
  value = "${aws_db_instance.gitlab.port}"
}

output "gitlab_db_endpoint" {
  value = "${aws_db_instance.gitlab.endpoint}"
}


output "gitlab_data_dns1" {
  value = "${aws_efs_mount_target.gitlab1.dns_name}"
}

output "gitlab_data_ip1" {
  value = "${aws_efs_mount_target.gitlab1.ip_address}"
}

output "gitlab_data_dns2" {
  value = "${aws_efs_mount_target.gitlab2.dns_name}"
}

output "gitlab_data_ip2" {
  value = "${aws_efs_mount_target.gitlab2.ip_address}"
}

output "gitlab_cache_endpoint" {
  value = "${aws_elasticache_cluster.gitlab_cache.cache_nodes.0.endpoint}"
}

output "gitlab_cache_address" {
  value = "${aws_elasticache_cluster.gitlab_cache.cache_nodes.0.address}"
}
output "gitlab_cache_port" {
  value = "${aws_elasticache_cluster.gitlab_cache.cache_nodes.0.port}"
}
