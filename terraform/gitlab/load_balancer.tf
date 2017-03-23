resource "aws_security_group" "gitlab_elb" {
  name        = "gitlab-elb"
  description = "Allow inbound traffic on gitlab load balancer"
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

resource "aws_elb" "gitlab" {
  name               = "gitlab"
  security_groups    = ["${aws_security_group.gitlab_elb.id}"]
  subnets            = ["${var.public_subnet_ids["public1"]}"]
  cross_zone_load_balancing   = false
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 22
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  /*listener {
    instance_port      = 443
    instance_protocol  = "https"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  }*/

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    // check "/explore" for OK (200), because "/" redirect (302) to "/user/sign_in"
    target              = "HTTP:80/explore"
    interval            = 30
  }

  tags {
    Name = "gitlab-elb"
  }
}
