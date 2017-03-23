resource "aws_security_group" "gitlab_data" {
  name        = "gitlab_data"
  description = "Allow inbound traffic on gitlab data NFS mountpoints"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "TCP"
    security_groups = ["${aws_security_group.gitlab.id}"]
  }
}

resource "aws_efs_file_system" "gitlab_data" {
  creation_token = "gitlab-data"
  performance_mode = "generalPurpose"
  tags {
    Name = "gitlab-data"
  }
}

resource "aws_efs_mount_target" "gitlab1" {
  file_system_id = "${aws_efs_file_system.gitlab_data.id}"
  subnet_id = "${var.private_subnet_ids["private1"]}"
  security_groups = ["${aws_security_group.gitlab_data.id}"]
  depends_on = [
    "aws_efs_file_system.gitlab_data"
  ]
}

resource "aws_efs_mount_target" "gitlab2" {
  file_system_id = "${aws_efs_file_system.gitlab_data.id}"
  subnet_id = "${var.private_subnet_ids["private2"]}"
  security_groups = ["${aws_security_group.gitlab_data.id}"]
  depends_on = [
    "aws_efs_file_system.gitlab_data"
  ]
}
