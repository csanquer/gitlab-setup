/*****************************************/
/*               NFS mounts             */
/*****************************************/

resource "aws_security_group" "gitlab_data" {
  name        = "gitlab_data"
  description = "Allow inbound traffic on gitlab data NFS mountpoints"
  vpc_id      = "${aws_vpc.gitlab.id}"

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
  subnet_id = "${aws_subnet.private1.id}"
  security_groups = ["${aws_security_group.gitlab_data.id}"]
  depends_on = [
    "aws_efs_file_system.gitlab_data"
  ]
}

resource "aws_efs_mount_target" "gitlab2" {
  file_system_id = "${aws_efs_file_system.gitlab_data.id}"
  subnet_id = "${aws_subnet.private2.id}"
  security_groups = ["${aws_security_group.gitlab_data.id}"]
  depends_on = [
    "aws_efs_file_system.gitlab_data"
  ]
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

/*****************************************/
/*               Redis Cache             */
/*****************************************/

resource "aws_elasticache_subnet_group" "gitlab_cache" {
    name = "gitlab-cache-subnet"
    subnet_ids = ["${aws_subnet.private1.id}", "${aws_subnet.private2.id}"]
}

resource "aws_elasticache_cluster" "gitlab_cache" {
    cluster_id = "gitlab-cache"
    engine = "redis"
    engine_version = "3.2.4"
    node_type = "cache.t2.small"
    port = 6379
    num_cache_nodes = 1
    parameter_group_name = "default.redis3.2"
    subnet_group_name = "${aws_elasticache_subnet_group.gitlab_cache.name}"
    security_group_ids = ["${aws_security_group.gitlab_cache.id}"]
}

resource "aws_security_group" "gitlab_cache" {
  name        = "gitlab-cache"
  description = "Allow traffic to gitlab cache"
  vpc_id      = "${aws_vpc.gitlab.id}"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "TCP"
    security_groups = ["${aws_security_group.bastions.id}", "${aws_security_group.gitlab.id}"]
  }
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

/*****************************************/
/*                Database               */
/*****************************************/

resource "aws_security_group" "db_allow" {
  name        = "db_allow"
  description = "Allow inbound traffic to databases"
  vpc_id      = "${aws_vpc.gitlab.id}"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "TCP"
    security_groups = ["${aws_security_group.bastions.id}", "${aws_security_group.gitlab.id}"]
  }
}

resource "aws_db_subnet_group" "gitlab_db_sg" {
  name       = "gitlab-db"
  subnet_ids = ["${aws_subnet.private1.id}", "${aws_subnet.private2.id}"]

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

output "gitlab_db_address" {
  value = "${aws_db_instance.gitlab.address}"
}

output "gitlab_db_port" {
  value = "${aws_db_instance.gitlab.port}"
}

output "gitlab_db_endpoint" {
  value = "${aws_db_instance.gitlab.endpoint}"
}
