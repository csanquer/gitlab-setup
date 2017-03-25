data "aws_ami" "gitlab_runner" {
  owners      = ["self"]
  most_recent = true
  filter {
    name   = "tag:application"
    values = ["gitlab-ci-runner"]
  }
}

resource "aws_iam_role" "gitlab_ci_iam_role" {
    name = "gitlab_ci_iam_role"
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

resource "aws_iam_role_policy" "gitlab_ci_iam_role_policy" {
  name = "gitlab_ci_iam_role_policy"
  role = "${aws_iam_role.gitlab_ci_iam_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::${var.gitlab_init_bucket}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": ["arn:aws:s3:::${var.gitlab_init_bucket}/gitlab-ci/*"]
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "gitlab_ci_instance_profile" {
  name = "gitlab_ci_instance_profile"
  roles = ["${aws_iam_role.gitlab_ci_iam_role.name}"]
}

resource "aws_security_group" "gitlab_ci" {
  name        = "gitlab_ci"
  description = "Allow inbound traffic on gitlab ci runner instances"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    security_groups = ["${var.sg_bastions_id}", "${var.sg_gitlab_id}"]
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

resource "aws_instance" "gitlab_ci" {
  ami                                  = "${data.aws_ami.gitlab_runner.id}"
  instance_type                        = "t2.micro"
  associate_public_ip_address          = false
  subnet_id                            = "${var.private_subnet_ids["private1"]}"
  vpc_security_group_ids               = ["${aws_security_group.gitlab_ci.id}"]
  instance_initiated_shutdown_behavior = "terminate"
  key_name                             = "${var.admin_ssh_key}"
  iam_instance_profile                 = "${aws_iam_instance_profile.gitlab_ci_instance_profile.id}"

  user_data = <<EOF
#cloud-config
runcmd:
  - aws s3 cp --recursive s3://gitlab-init-secret/gitlab-ci/ /root/launch
  - cd /root/launch
  - bash ./gitlab_ci_bootstrap.sh

output: { all : '| tee -a /var/log/cloud-init-output.log' }
EOF

  tags {
    Name = "gitlab-ci"
  }

  depends_on = [
    "aws_s3_bucket_object.gitlab_ci_env_yml",
    "aws_s3_bucket_object.gitlab_ci_env_sh",
    "aws_s3_bucket_object.gitlab_ci_config",
    "aws_s3_bucket_object.gitlab_ci_bootstrap"
  ]
}
