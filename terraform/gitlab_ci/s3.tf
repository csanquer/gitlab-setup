data "template_file" "gitlab_ci_env_yml" {
    template = "${file("${path.module}/config/gitlab_ci_env.yml")}"

    vars {
        gitlab_external_protocol = "http"
        gitlab_external_host = "${var.gitlab_host}"
        gitlab_ci_registration_token = "${var.gitlab_ci_registration_token}"
    }
}

data "template_file" "gitlab_ci_env_sh" {
    template = "${file("${path.module}/config/gitlab_ci_env.sh")}"

    vars {
        gitlab_external_protocol = "http"
        gitlab_external_host = "${var.gitlab_host}"
        gitlab_ci_registration_token = "${var.gitlab_ci_registration_token}"
    }
}

resource "aws_s3_bucket_object" "gitlab_ci_env_yml" {
  key                    = "gitlab-ci/gitlab_ci_env.yml"
  bucket                 = "${var.gitlab_init_bucket}"
  content                = "${data.template_file.gitlab_ci_env_yml.rendered}"
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "gitlab_ci_env_sh" {
  key                    = "gitlab-ci/gitlab_ci_env.sh"
  bucket                 = "${var.gitlab_init_bucket}"
  content                = "${data.template_file.gitlab_ci_env_sh.rendered}"
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "gitlab_ci_config" {
  key                    = "gitlab-ci/runner_config.toml.j2"
  bucket                 = "${var.gitlab_init_bucket}"
  content                = "${file("${path.module}/config/runner_config.toml.j2")}"
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "gitlab_ci_bootstrap" {
  key                    = "gitlab-ci/gitlab_ci_bootstrap.sh"
  bucket                 = "${var.gitlab_init_bucket}"
  content                = "${file("${path.module}/config/gitlab_ci_bootstrap.sh")}"
  server_side_encryption = "AES256"
}
