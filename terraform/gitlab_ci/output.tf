output "gitlab_ci_env_yml_bucket_key" {
  value = "${aws_s3_bucket_object.gitlab_ci_env_yml.key}"
}

output "gitlab_ci_env_sh_bucket_key" {
  value = "${aws_s3_bucket_object.gitlab_ci_env_sh.key}"
}

output "gitlab_ci_config_bucket_key" {
  value = "${aws_s3_bucket_object.gitlab_ci_config.key}"
}

output "gitlab_ci_bootstrap_bucket_key" {
  value = "${aws_s3_bucket_object.gitlab_ci_bootstrap.key}"
}
