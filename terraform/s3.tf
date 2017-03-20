data "template_file" "encrypt_s3" {
    template = "${file("${path.cwd}/s3_policy/encrypt_s3_object.tpl")}"

    vars {
        bucket_name = "${var.gitlab_secret_bucket}"
    }
}

resource "aws_s3_bucket" "gitlab_init" {
  bucket = "${var.gitlab_secret_bucket}"
  acl = "private"
  policy = "${data.template_file.encrypt_s3.rendered}"

  versioning {
    enabled = true
  }

  tags {
    Name = "init"
  }
}
/*************************************************************************/

data "template_file" "gitlab_env_yml" {
    template = "${file("${path.cwd}/config/gitlab_env.yml")}"

    vars {
        gitlab_external_url = ""
        gitlab_db_name = "${var.gitlab_db_name}"
        gitlab_db_username = "${var.gitlab_db_username}"
        gitlab_db_password = "${var.gitlab_db_password}"
        gitlab_root_password = "${var.gitlab_root_password}"
        gitlab_ci_registration_token = "${var.gitlab_ci_registration_token}"
        gitlab_db_host = "${aws_db_instance.gitlab.address}"
        gitlab_db_port = "${aws_db_instance.gitlab.port}"
        gitlab_cache_host = "${aws_elasticache_cluster.gitlab_cache.cache_nodes.0.address}"
        gitlab_cache_port = "${aws_elasticache_cluster.gitlab_cache.cache_nodes.0.port}"
    }
}

data "template_file" "gitlab_env_sh" {
    template = "${file("${path.cwd}/config/gitlab_env.sh")}"

    vars {
        gitlab_external_url = ""
        gitlab_db_host = "${aws_db_instance.gitlab.address}"
        gitlab_db_port = "${aws_db_instance.gitlab.port}"
        gitlab_cache_host = "${aws_elasticache_cluster.gitlab_cache.cache_nodes.0.address}"
        gitlab_cache_port = "${aws_elasticache_cluster.gitlab_cache.cache_nodes.0.port}"
        gitlab_nfs_host = "${aws_efs_file_system.gitlab_data.id}.efs.${var.aws_region}.amazonaws.com"
        gitlab_nfs_zone1_host = "${aws_efs_mount_target.gitlab1.dns_name}"
        gitlab_nfs_zone1_ip = "${aws_efs_mount_target.gitlab1.ip_address}"
        gitlab_nfs_zone2_host = "${aws_efs_mount_target.gitlab2.dns_name}"
        gitlab_nfs_zone2_ip = "${aws_efs_mount_target.gitlab2.ip_address}"
    }
}

resource "aws_s3_bucket_object" "gitlab_env_yml" {
  key                    = "gitlab/gitlab_env.yml"
  bucket                 = "${aws_s3_bucket.gitlab_init.bucket}"
  content                = "${data.template_file.gitlab_env_yml.rendered}"
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "gitlab_env_sh" {
  key                    = "gitlab/gitlab_env.sh"
  bucket                 = "${aws_s3_bucket.gitlab_init.bucket}"
  content                = "${data.template_file.gitlab_env_sh.rendered}"
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "gitlab_config" {
  key                    = "gitlab/gitlab.rb.j2"
  bucket                 = "${aws_s3_bucket.gitlab_init.bucket}"
  content                = "${file("${path.cwd}/config/gitlab.rb.j2")}"
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "gitlab_bootstrap" {
  key                    = "gitlab/gitlab_bootstrap.sh"
  bucket                 = "${aws_s3_bucket.gitlab_init.bucket}"
  content                = "${file("${path.cwd}/config/gitlab_bootstrap.sh")}"
  server_side_encryption = "AES256"
}

/*************************************************************************/

data "template_file" "gitlab_ci_env_yml" {
    template = "${file("${path.cwd}/config/gitlab_ci_env.yml")}"

    vars {
        gitlab_external_url = ""
        gitlab_ci_registration_token = "${var.gitlab_ci_registration_token}"
    }
}

resource "aws_s3_bucket_object" "gitlab_ci_env_yml" {
  key                    = "gitlab-ci/gitlab-ci-env"
  bucket                 = "${aws_s3_bucket.gitlab_init.bucket}"
  content                = "${data.template_file.gitlab_ci_env_yml.rendered}"
  server_side_encryption = "AES256"
}

/*************************************************************************/

output "gitlab_init_bucket_arn" {
  value = "${aws_s3_bucket.gitlab_init.arn}"
}

output "gitlab_init_bucket_name" {
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

output "gitlab_ci_env_yml_bucket_key" {
  value = "${aws_s3_bucket_object.gitlab_ci_env_yml.key}"
}
