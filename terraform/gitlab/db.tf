resource "aws_security_group" "db_allow" {
  name        = "db_allow"
  description = "Allow inbound traffic to databases"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "TCP"
    security_groups = ["${aws_security_group.gitlab.id}"]
  }
}

resource "aws_db_subnet_group" "gitlab_db_sg" {
  name       = "gitlab-db"
  subnet_ids = ["${var.private_subnet_ids["private1"]}", "${var.private_subnet_ids["private2"]}"]

  tags {
    Name = "Gitlab DB subnet group"
  }
}

resource "aws_db_parameter_group" "pg_default" {
    name = "gitlab-postgres-pg"
    family = "postgres9.5"

    parameter {
      name = "client_encoding"
      value = "utf8"
    }
}

resource "aws_db_instance" "gitlab" {
  allocated_storage         = 10
  engine                    = "postgres"
  engine_version            = "9.5.4"
  license_model             = "postgresql-license"
  instance_class            = "db.t2.micro"
  name                      = "${var.gitlab_db_name}"
  username                  = "${var.gitlab_db_username}"
  password                  = "${var.gitlab_db_password}"
  db_subnet_group_name      = "${aws_db_subnet_group.gitlab_db_sg.name}"
  vpc_security_group_ids    = ["${aws_security_group.db_allow.id}"]
  // parameter_group_name      = "default.postgres9.5"
  parameter_group_name      = "${aws_db_parameter_group.pg_default.name}"
  storage_type              = "gp2"
  publicly_accessible       = true
  final_snapshot_identifier = "gitlab-db"
  skip_final_snapshot       = true
  copy_tags_to_snapshot     = true
  backup_retention_period   = 1
  apply_immediately         = true
  multi_az                  = false
}
