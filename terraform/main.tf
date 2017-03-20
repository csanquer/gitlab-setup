provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

data "aws_ami" "ubuntu_xenial" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "admin" {
  key_name   = "admin"
  public_key = "${var.admin_ssh_public_key}"
}

resource "aws_security_group" "bastions" {
  name        = "bastions"
  description = "Allow SSH access to bastions"
  vpc_id      = "${aws_vpc.gitlab.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["${var.sg_ssh_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion1" {
  ami                                  = "${data.aws_ami.ubuntu_xenial.id}"
  instance_type                        = "t2.micro"
  associate_public_ip_address          = true
  subnet_id                            = "${aws_subnet.public1.id}"
  vpc_security_group_ids               = ["${aws_security_group.bastions.id}"]
  instance_initiated_shutdown_behavior = "terminate"
  key_name                             = "${aws_key_pair.admin.key_name}"

  tags {
    Name = "bastion1"
  }
}

output "ubuntu_xenial_ami" {
  value = "${data.aws_ami.ubuntu_xenial.id}"
}

output "bastion1_ip" {
  value = "${aws_instance.bastion1.public_ip}"
}

output "bastion1_address" {
  value = "${aws_instance.bastion1.public_dns}"
}
