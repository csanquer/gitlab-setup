data "aws_ami" "gitlab" {
  owners      = ["self"]
  most_recent = true
  filter {
    name   = "tag:application"
    values = ["gitlab"]
  }
}

resource "aws_iam_role" "gitlab_iam_role" {
    name = "gitlab_iam_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "gitlab_iam_role_policy" {
  name = "gitlab_iam_role_policy"
  role = "${aws_iam_role.gitlab_iam_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::${aws_s3_bucket.gitlab_init.bucket}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": ["arn:aws:s3:::${aws_s3_bucket.gitlab_init.bucket}/gitlab/*"]
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "gitlab_instance_profile" {
  name = "gitlab_instance_profile"
  roles = ["${aws_iam_role.gitlab_iam_role.name}"]
}

resource "aws_security_group" "gitlab" {
  name        = "gitlab"
  description = "Allow inbound traffic on gitlab instances"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_launch_configuration" "gitlab" {
  name_prefix               = "gitlab-"
  image_id                  = "${data.aws_ami.gitlab.id}"
  instance_type             = "t2.medium"
  key_name                  = "${var.admin_ssh_key}"
  security_groups           = ["${aws_security_group.gitlab.id}"]
  iam_instance_profile      = "${aws_iam_instance_profile.gitlab_instance_profile.id}"

  user_data = <<EOF
#cloud-config
runcmd:
  - aws s3 cp --recursive s3://gitlab-init-secret/gitlab/ /root/launch
  - cd /root/launch
  - bash ./gitlab_bootstrap.sh

output: { all : '| tee -a /var/log/cloud-init-output.log' }
EOF

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    "aws_efs_file_system.gitlab_data",
    "aws_efs_mount_target.gitlab1",
    "aws_efs_mount_target.gitlab2",
    "aws_elasticache_cluster.gitlab_cache",
    "aws_db_instance.gitlab",
    "aws_s3_bucket.gitlab_init",
    "aws_s3_bucket_object.gitlab_env_yml",
    "aws_s3_bucket_object.gitlab_env_sh",
    "aws_s3_bucket_object.gitlab_config",
    "aws_s3_bucket_object.gitlab_bootstrap"
  ]
}


resource "aws_autoscaling_group" "gitlab" {
  name                      = "gitlab"
  max_size                  = "${var.gitlab_max}"
  min_size                  = "${var.gitlab_min}"
  desired_capacity          = "${var.gitlab_desired}"
  vpc_zone_identifier       = ["${var.private_subnet_ids["private1"]}"]
  health_check_grace_period = 300
  health_check_type         = "ELB"
  default_cooldown          = 180
  force_delete              = true
  load_balancers            = ["${aws_elb.gitlab.name}"]
  launch_configuration      = "${aws_launch_configuration.gitlab.name}"
  wait_for_capacity_timeout = "15m"

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "application"
    value               = "gitlab"
    propagate_at_launch = true
  }

  depends_on = [
    "aws_efs_file_system.gitlab_data",
    "aws_efs_mount_target.gitlab1",
    "aws_efs_mount_target.gitlab2",
    "aws_elasticache_cluster.gitlab_cache",
    "aws_db_instance.gitlab",
    "aws_s3_bucket.gitlab_init",
    "aws_s3_bucket_object.gitlab_env_yml",
    "aws_s3_bucket_object.gitlab_env_sh",
    "aws_s3_bucket_object.gitlab_config",
    "aws_s3_bucket_object.gitlab_bootstrap"
  ]
}

/*
resource "aws_elb_attachment" "gitlab" {
  elb      = "${aws_elb.gitlab.id}"
  instance = "${aws_instance.gitlab.id}"
}

resource "aws_instance" "gitlab" {
  ami                                  = "${data.aws_ami.gitlab.id}"
  instance_type                        = "t2.medium"
  associate_public_ip_address          = false
  subnet_id                            = "${aws_subnet.private1.id}"
  vpc_security_group_ids               = ["${aws_security_group.gitlab.id}"]
  instance_initiated_shutdown_behavior = "terminate"
  key_name                             = "${aws_key_pair.admin.key_name}"
  iam_instance_profile                 = "${aws_iam_instance_profile.gitlab_instance_profile.id}"

  user_data = <<EOF
#cloud-config
runcmd:
  - aws s3 cp --recursive s3://gitlab-init-secret/gitlab/ /root/launch
  - cd /root/launch
  - bash ./gitlab_bootstrap.sh

output: { all : '| tee -a /var/log/cloud-init-output.log' }
EOF

  tags {
    Name = "gitlab"
  }

  depends_on = [
    "aws_efs_file_system.gitlab_data",
    "aws_efs_mount_target.gitlab1",
    "aws_efs_mount_target.gitlab2",
    "aws_elasticache_cluster.gitlab_cache",
    "aws_db_instance.gitlab",
    "aws_s3_bucket.gitlab_init",
    "aws_s3_bucket_object.gitlab_env_yml",
    "aws_s3_bucket_object.gitlab_env_sh",
    "aws_s3_bucket_object.gitlab_config",
    "aws_s3_bucket_object.gitlab_bootstrap"
  ]
}*/
